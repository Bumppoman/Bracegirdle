# frozen_string_literal: true

class ComplaintsController < ApplicationController
  include Permissions

  before_action do
    stipulate :must_be_investigator
  end

  def all
    @complaints = Complaint.all

    @title = 'All Complaints'
    @breadcrumbs = { 'All complaints' => nil }

    render :index
  end

  def create
    @complaint = Complaint.new(complaint_params)

    # Link to cemetery if cemetery is regulated
    begin
      @complaint.cemetery = Cemetery.find(params.dig(:complaint, :cemetery)) if @complaint.cemetery_regulated?
    rescue ActiveRecord::RecordNotFound
      @complaint.cemetery = nil
    end

    # Update dates
    @complaint.update(complaint_date_params)

    # Update complaint types and manners of contact
    @complaint.complaint_type = params[:complaint][:complaint_type].reject(&:empty?).join(', ')
    @complaint.manner_of_contact = params.dig(:complaint, :manner_of_contact).try(:join, ', ')

    @complaint.receiver = User.find(params.dig(:complaint, :receiver))

    if @complaint.investigation_required?
      @complaint.investigator = User.find(params[:complaint][:investigator]) unless params[:complaint][:investigator].blank?
    else
      if current_user.has_role?(:supervisor)
        @complaint.status = 5
        @complaint.closed_by = current_user
        @complaint.closure_date = Date.current
      else
        @complaint.status = 4
      end

      @complaint.investigator = current_user
      @complaint.disposition_date = Date.current
      @complaint.disposition = params[:complaint][:disposition]
    end

    if @complaint.save
      redirect_to @complaint
    else
      @title = 'Add New Complaint'
      @breadcrumbs = { 'Add new complaint' => nil }

      render action: :new
    end
  end

  def index
    @complaints = Complaint.where(investigator: current_user).where('status < ?', 4).includes(:cemetery)

    @title = 'My Active Complaints'
    @breadcrumbs = { 'My active complaints' => nil }
  end

  def new
    @complaint = Complaint.new(receiver: current_user, date_acknowledged: Date.current)

    @title = 'Add New Complaint'
    @breadcrumbs = { 'Add new complaint' => nil }
  end

  def pending_closure
    @complaints = Complaint.pending_closure

    @title = 'Complaints Pending Closure'
    @breadcrumbs = { 'Complaints pending closure' => nil }

    render :index
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
    complete_investigation if params.key?(:complete_investigation)
    recommend_closure if params.key? :recommend_closure
    reopen_investigation and return if params.key? :reopen_investigation
    close_complaint and return if params.key? :close_complaint

    if @complaint.save
      respond_to do |m|
        m.js { render partial: @response }
      end
    end
  end

  private

  def assign_complaint
    @response = 'complaints/update/assign_complaint'
  end

  def assign_investigator
    @complaint.status = 2
    @complaint.investigation_begin_date = Date.current
    @complaint.investigator = User.find(params[:complaint][:investigator])
    @response = 'complaints/update/assign_investigator'
  end

  def begin_investigation
    @complaint.status = 2
    @complaint.investigator = current_user
    @complaint.investigation_begin_date = Date.current
    @response = 'complaints/update/begin_investigation'
  end

  def close_complaint
    if @complaint.status == 3
      @complaint.disposition_date = Date.current
      @complaint.disposition = params[:complaint][:disposition]
    end

    @complaint.status = 5
    @complaint.closed_by = current_user
    @complaint.closure_date = Date.current

    redirect_to complaint_investigation_path(@complaint) if @complaint.save
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
    %i[date_of_event date_complained_to_cemetery].each do |param|
      if params[:complaint][param].match? %r{[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}}
        date_params[param] = Date.strptime(params[:complaint][param], '%m/%d/%Y')
      else
        date_params[param] = Date.parse(params[:complaint][param]) rescue nil
      end
    end

    date_params
  end

  def complete_investigation
    @complaint.status = 3
    @complaint.investigation_completion_date = Date.current
    @response = 'complaints/update/complete_investigation'
  end

  def recommend_closure
    @complaint.update(
      status: 4,
      disposition_date: Date.current,
      disposition: params[:complaint][:disposition]
    )
    @response = 'complaints/update/recommend_closure'
  end

  def reopen_investigation
    @complaint.update(
      status: 2,
      investigation_required: true,
      investigator: current_user,
      investigation_completion_date: nil,
      disposition_date: nil,
      disposition: nil
    )

    @complaint.investigation_begin_date = Date.current if @complaint.investigation_begin_date.nil?

    redirect_to complaint_investigation_path(@complaint) if @complaint.save
  end
end
