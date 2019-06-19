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
      investigation_begin_date: Date.current,
      investigator: User.find(params[:complaint][:investigator]))

    respond_to do |f|
      f.js { render partial: 'complaints/update/assign_complaint' }
    end
  end

  def begin_investigation
    @complaint = Complaint.find(params[:id])
    @complaint.update(
      status: :investigation_begun,
      investigator: current_user,
      investigation_begin_date: Date.current)

    respond_to do |f|
      f.js { render partial: 'complaints/update/begin_investigation' }
    end
  end

  def change_investigator
    @complaint = Complaint.find(params[:id])
    @complaint.update(investigator: User.find(params[:complaint][:investigator]))

    respond_to do |f|
      f.js { render partial: 'complaints/update/change_investigator' }
    end
  end

  def close_complaint
    @complaint = Complaint.find(params[:id])

    if params.key? :recommend_closure
      @complaint.update(
          status: :pending_closure,
          disposition_date: Date.current,
          disposition: params[:complaint][:disposition])

      respond_to do |f|
        f.js { render partial: 'complaints/update/recommend_closure' }
      end
    elsif params.key? :close_complaint
      if @complaint.investigation_completed?
        @complaint.update(
          disposition_date: Date.current,
          disposition: params[:complaint][:disposition])
      end

      @complaint.update(
        status: :closed,
        closed_by: current_user,
        closure_date: Date.current,
        closure_review_comments: params[:complaint][:closure_review_comments])

      redirect_to complaint_investigation_path(@complaint)
    end
  end

  def complete_investigation
    @complaint = Complaint.find(params[:id])
    @complaint.update(
      status: :investigation_completed,
      investigation_completion_date: Date.current)
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
    else
      if current_user.supervisor?
        @complaint.assign_attributes(
          status: :closed,
          closed_by: current_user,
          closure_date: Date.current)
      else
        @complaint.status = :pending_closure
      end

      @complaint.assign_attributes(
        investigator: current_user,
        disposition_date: Date.current,
        disposition: params[:complaint][:disposition])
    end

    if @complaint.save
      Complaints::ComplaintAddEvent.new(@complaint, current_user).trigger
      redirect_to @complaint
    else
      render action: :new
    end
  end

  def reopen_investigation
    @complaint = Complaint.find(params[:id])
    @complaint.update(
      status: :investigation_begun,
      investigation_required: true,
      investigator: current_user,
      investigation_completion_date: nil,
      disposition_date: nil,
      disposition: nil)

    @complaint.investigation_begin_date = Date.current if @complaint.investigation_begin_date.nil?

    redirect_to complaint_investigation_path(@complaint) if @complaint.save
  end

  def index
    @complaints = current_user.complaints.includes(:cemetery)
  end

  def new
    @complaint = Complaint.new(receiver: current_user)
  end

  def pending_closure
    @complaints = Complaint.includes(:cemetery).pending_closure
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
      :complainant_name, :complainant_address, :complainant_address,
      :complainant_email, :complainant_phone, :cemetery_regulated,
      :cemetery_county, :cemetery_alternate_name, :lot_location,
      :name_on_deed, :relationship, :ownership_type,
      :summary, :form_of_relief, :person_contacted,
      :attorney_contacted, :court_action_pending, :investigation_required
    )
  end

  def complaint_date_params
    date_params %w(date_of_event date_complained_to_cemetery), params[:complaint]
  end
end
