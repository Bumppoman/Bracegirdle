# frozen_string_literal: true

class ComplaintsController < ApplicationController
  include Permissions

  before_action do
    stipulate :must_be_investigator
  end

  def all
    @complaints = Complaint.includes(:cemetery).all
  end

  def assign_complaint
    @complaint = Complaint.find(params[:id])
    @complaint.update(
      status: :investigation_begun,
      investigator: User.find(params[:complaint][:investigator]))
    Complaints::ComplaintAssignEvent.new(@complaint, current_user).trigger

    respond_to do |f|
      f.js { render partial: 'complaints/update/assign_complaint' }
    end
  end

  def begin_investigation
    @complaint = Complaint.find(params[:id])
    @complaint.update(
      status: :investigation_begun,
      investigator: current_user)
    Complaints::ComplaintBeginInvestigationEvent.new(@complaint, current_user).trigger

    respond_to do |f|
      f.js { render partial: 'complaints/update/begin_investigation' }
    end
  end

  def change_investigator
    @complaint = Complaint.find(params[:id])
    @complaint.update(investigator: User.find(params[:complaint][:investigator]))
    Complaints::ComplaintReassignEvent.new(@complaint, current_user).trigger

    respond_to do |f|
      f.js { render partial: 'complaints/update/change_investigator' }
    end
  end

  def close_complaint
    @complaint = Complaint.find(params[:id])

    if params.key? :recommend_closure
      @complaint.update(
        status: :pending_closure,
        disposition: params[:complaint][:disposition])
      Complaints::ComplaintRecommendClosureEvent.new(@complaint, current_user).trigger

      respond_to do |f|
        f.js { render partial: 'complaints/update/recommend_closure' }
      end
    elsif params.key? :close_complaint
      @complaint.disposition = params[:complaint][:disposition] if @complaint.investigation_completed?

      @complaint.update(
        status: :closed,
        closed_by: current_user,
        closure_review_comments: params[:complaint][:closure_review_comments])
      Complaints::ComplaintCloseEvent.new(@complaint, current_user).trigger

      redirect_to complaint_investigation_path(@complaint)
    end
  end

  def complete_investigation
    @complaint = Complaint.find(params[:id])
    @complaint.update(status: :investigation_completed)
    Complaints::ComplaintCompleteInvestigationEvent.new(@complaint, current_user).trigger

    respond_to do |f|
      f.js { render partial: 'complaints/update/complete_investigation' }
    end
  end

  def create
    @complaint = Complaint.new(complaint_params)

    # Link to cemetery if cemetery is regulated
    @complaint.cemetery = Cemetery.find_by(id: params.dig(:complaint, :cemetery))

    # Update dates
    @complaint.assign_attributes(complaint_date_params)

    # Update complaint types and manners of contact
    @complaint.assign_attributes(
      complaint_type: params[:complaint][:complaint_type].reject(&:empty?).join(', '),
      manner_of_contact: params.dig(:complaint, :manner_of_contact).try(:join, ', '),
      receiver: User.find(params[:complaint][:receiver])
    )

    if @complaint.investigation_required?
      @complaint.investigator = User.find(params[:complaint][:investigator]) unless params[:complaint][:investigator].blank?
      if @complaint.investigator == @complaint.receiver
        event = Complaints::ComplaintBeginInvestigationEvent
        @complaint.status = :investigation_begun
      else
        event = Complaints::ComplaintAddEvent
      end
    else
      if current_user.supervisor?
        event = Complaints::ComplaintCloseEvent
        @complaint.assign_attributes(
          status: :closed,
          closed_by: current_user)
      else
        event = Complaints::ComplaintRecommendClosureEvent
        @complaint.status = :pending_closure
      end

      @complaint.assign_attributes(
        investigator: current_user,
        disposition: params[:complaint][:disposition])
    end

    if @complaint.save
      event.new(@complaint, current_user).trigger
      redirect_to @complaint
    else
      render action: :new
    end
  end

  def index
    @user = params.key?(:user) ? User.find(params[:user]) : current_user
    @complaints = @user.complaints.includes(:cemetery)
  end

  def new
    @complaint = Complaint.new(receiver: current_user, complainant_state: 'NY')
  end

  def pending_closure
    @complaints = Complaint.includes(:cemetery).pending_closure
  end

  def reopen_investigation
    @complaint = Complaint.find(params[:id])
    @complaint.update(
        status: :investigation_begun,
        investigation_required: true,
        investigator: current_user,
        disposition: nil)
    Complaints::ComplaintBeginInvestigationEvent.new(@complaint, current_user).trigger

    redirect_to complaint_investigation_path(@complaint)
  end

  def request_update
    @complaint = Complaint.find(params[:id])
    @note = @complaint.notes.create(user: current_user, body: 'Please provide an update on the status of this complaint.')
    Complaints::ComplaintRequestUpdateEvent.new(@complaint, current_user).trigger

    respond_to do |f|
      f.js { render partial: 'complaints/update/request_update' }
    end
  end

  def show
    @complaint = Complaint.includes(:cemetery, attachments: { file_attachment: :blob }).find(params[:id])
  end

  def unassigned
    @complaints = Complaint.includes(:cemetery).unassigned
  end

  private

  def complaint_params
    params.require(:complaint).permit(
      :complainant_name, :complainant_street_address, :complainant_city,
      :complainant_state, :complainant_zip, :complainant_email, :complainant_phone,
      :cemetery_regulated, :cemetery_county, :cemetery_alternate_name, :lot_location,
      :name_on_deed, :relationship, :ownership_type, :summary, :form_of_relief,
      :person_contacted, :attorney_contacted, :court_action_pending, :investigation_required
    )
  end

  def complaint_date_params
    date_params %w(date_of_event date_complained_to_cemetery), params[:complaint]
  end
end
