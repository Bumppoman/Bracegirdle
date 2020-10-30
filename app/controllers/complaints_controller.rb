# frozen_string_literal: true

class ComplaintsController < ApplicationController
  def all
    @complaints = authorize Complaint.includes(:cemetery).all
  end

  def assign
    @complaint = authorize Complaint.find(params[:id])
    @complaint.update(
      status: :investigation_begun,
      investigator: User.find(params[:complaint][:investigator]))
    Complaints::ComplaintAssignEvent.new(@complaint, current_user).trigger

    respond_to do |f|
      f.js { render partial: 'complaints/investigation/assign' }
    end
  end

  def begin_investigation
    @complaint = authorize Complaint.find(params[:id])
    @complaint.update(
      status: :investigation_begun,
      investigator: current_user
    )
    Complaints::ComplaintBeginInvestigationEvent.new(@complaint, current_user).trigger
    
    # Re-render the tracker
    @tracker = render_to_string partial: 'complaints/investigation/investigation_begun'

    respond_to do |f|
      f.js { render partial: 'complaints/investigation/begin_investigation' }
    end
  end

  def close
    @complaint = authorize Complaint.find(params[:id])
    @complaint.disposition = params[:complaint][:disposition] if @complaint.investigation_completed?
    @complaint.update(
      status: :closed,
      closed_by: current_user,
      closure_review_comments: params[:complaint][:closure_review_comments]
    )
    Complaints::ComplaintCloseEvent.new(@complaint, current_user).trigger

    redirect_to investigation_complaint_path(@complaint)
  end

  def complete_investigation
    @complaint = authorize Complaint.find(params[:id])
    @complaint.update(status: :investigation_completed)
    Complaints::ComplaintCompleteInvestigationEvent.new(@complaint, current_user).trigger

    respond_to do |f|
      f.js { render partial: 'complaints/investigation/complete_investigation' }
    end
  end

  def create
    @complaint = authorize Complaint.new(complaint_params)

    # Link to cemetery if cemetery is regulated
    @complaint.cemetery = Cemetery.find_by(cemid: params.dig(:complaint, :cemetery))

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
    @complaints = authorize current_user.complaints.includes(:cemetery)
  end

  def index_by_user
    @user = User.find(params[:user])
    @complaints = authorize @user.complaints.includes(:cemetery)
  end

  def new
    @complaint = authorize Complaint.new(receiver: current_user, complainant_state: 'NY')
  end
  
  def reassign
    @complaint = authorize Complaint.find(params[:id])
    @complaint.update(investigator: User.find(params[:complaint][:investigator]))
    Complaints::ComplaintReassignEvent.new(@complaint, current_user).trigger

    redirect_to investigation_complaint_path(@complaint)
  end
  
  def recommend_closure
    @complaint = authorize Complaint.find(params[:id])
    @complaint.update(
      status: :pending_closure,
      disposition: params[:complaint][:disposition])
    Complaints::ComplaintRecommendClosureEvent.new(@complaint, current_user).trigger

    respond_to do |f|
      f.js { render partial: 'complaints/investigation/recommend_closure' }
    end
  end

  def reopen_investigation
    @complaint = authorize Complaint.find(params[:id])
    @complaint.update(
      status: :investigation_begun,
      investigation_required: true,
      investigator: current_user,
      disposition: nil
    )
    Complaints::ComplaintBeginInvestigationEvent.new(@complaint, current_user).trigger

    redirect_to investigation_complaint_path(@complaint)
  end

  def request_update
    @complaint = authorize Complaint.find(params[:id])
    @note = @complaint.notes.create(user: current_user, body: 'Please provide an update on the status of this complaint.')
    Complaints::ComplaintRequestUpdateEvent.new(@complaint, current_user).trigger

    respond_to do |f|
      f.js { render partial: 'complaints/investigation/update_requested' }
    end
  end

  def show
    @complaint = authorize Complaint.includes(:cemetery, attachments: { file_attachment: :blob }).find(params[:id])
  end

  private

  def complaint_params
    params.require(:complaint).permit(
      :complainant_name, :complainant_street_address, :complainant_city,
      :complainant_state, :complainant_zip, :complainant_email, :complainant_phone,
      :cemetery_regulated, :cemetery_county, :cemetery_alternate_name, :date_of_event,
      :date_complained_to_cemetery, :lot_location, :name_on_deed, :relationship, 
      :ownership_type, :summary, :form_of_relief, :person_contacted, :attorney_contacted, 
      :court_action_pending, :investigation_required
    )
  end
end
