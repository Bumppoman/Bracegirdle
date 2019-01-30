# frozen_string_literal: true

class ComplaintsController < ApplicationController
  def create
    @complaint = Complaint.new(complaint_params)

    # Link to cemetery if cemetery is regulated
    @complaint.cemetery = Cemetery.find(params.dig(:complaint, :cemetery)) if @complaint.cemetery_regulated?

    # Update dates
    @complaint.update(complaint_date_params)

    # Update complaint types and manners of contact
    @complaint.complaint_type = params[:complaint][:complaint_type].reject(&:empty?).join(', ')
    @complaint.manner_of_contact = params.dig(:complaint, :manner_of_contact).try(:join, ', ')

    # Set receiver and investigator
    @complaint.receiver = User.find(params.dig(:complaint, :receiver))
    @complaint.investigator = User.find(params.dig(:complaint, :investigator)) if @complaint.investigation_required?

    if @complaint.save
      redirect_to @complaint
    else
      @title = 'Add New Complaint'
      @breadcrumbs = { 'Add new complaint' => nil }

      render action: :new
    end
  end

  def index
    @complaints = Complaint.where(investigator: current_user)

    @title = 'My Active Complaints'
    @breadcrumbs = { 'My active complaints' => nil }
  end

  def new
    @complaint = Complaint.new(receiver: current_user, date_acknowledged: Time.zone.today)

    @title = 'Add New Complaint'
    @breadcrumbs = { 'Add new complaint' => nil }
  end

  def show
    @complaint = Complaint.find(params[:id])

    @title = "Complaint ##{@complaint.complaint_number}"
    @breadcrumbs = { 'My active complaints' => complaints_path, @title => nil }
  end

  def unassigned
    @complaints = Complaint.unassigned

    @title = 'Unassigned Complaints'
    @breadcrumbs = { 'Unassigned complaints' => nil }

    render :index
  end

  def update_investigation
    @complaint = Complaint.find(params[:id])

    # Determine what to update
    begin_investigation if params.key?(:begin_investigation)
    assign_complaint if params.key?(:assign_complaint)
    assign_investigator if params.key?(:assign_investigator)

    progress_investigation
  end

  private

  def assign_complaint
    @response = 'complaints/update/assign_complaint'
  end

  def assign_investigator
    @complaint.status = 2
    @complaint.investigation_begin_date = Time.zone.today
    @complaint.investigator = User.find(params[:complaint][:investigator])
    @response = 'complaints/update/assign_investigator'
  end

  def begin_investigation
    @complaint.status = 2
    @complaint.investigator = current_user
    @complaint.investigation_begin_date = Time.zone.today
    @response = 'complaints/update/begin_investigation'
  end

  def complaint_params
    params.require(:complaint).permit(
      :complainant_name,
      :complainant_address,
      :complainant_address,
      :complainant_email,
      :complainant_phone,
      :cemetery_regulated,
      :cemetery_county,
      :cemetery_alternate_name,
      :lot_location,
      :name_on_deed,
      :relationship,
      :ownership_type,
      :summary,
      :form_of_relief,
      :person_contacted,
      :attorney_contacted,
      :court_action_pending,
      :investigation_required
    )
  end

  def complaint_date_params
    date_params = {}
    %i[date_of_event date_complained_to_cemetery date_acknowledged].each do |param|
      if params[:complaint][param].match? %r{[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}}
        date_params[param] = Date.strptime(params[:complaint][param], '%m/%d/%Y')
      else
        date_params[param] = Date.parse(params[:complaint][param]) rescue nil
      end
    end

    date_params
  end

  def progress_investigation
    respond_to do |m|
      m.js { render partial: @response }
    end
  end
end
