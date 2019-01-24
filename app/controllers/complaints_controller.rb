class ComplaintsController < ApplicationController

  def create
    # Set simple fields
    @complaint = Complaint.new(complaint_params)

    # Link to cemetery if cemetery is regulated
    @complaint.cemetery = Cemetery.find(params[:complaint][:cemetery]) if @complaint.cemetery_regulated? and not params[:complaint][:cemetery].blank?

    # Update dates
    @complaint.update(complaint_date_params)

    # Update complaint types and manners of contact
    @complaint.complaint_type = params[:complaint][:complaint_type].reject(&:empty?).join(", ")
    @complaint.manner_of_contact = params[:complaint][:manner_of_contact].join(", ") rescue nil

    # Set receiver and investigator
    @complaint.receiver = User.find(params[:complaint][:receiver]) unless params[:complaint][:receiver].blank?
    @complaint.investigator = User.find(params[:complaint][:investigator]) if @complaint.investigation_required? and not params[:complaint][:investigator].blank?

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

    @title = "My Active Complaints"
    @breadcrumbs = { "My active complaints" => nil }
  end

  def new
    @complaint = Complaint.new

    @title = 'Add New Complaint'
    @breadcrumbs = { 'Add new complaint' => nil }
  end

  def show

  end

  private
    def complaint_params
      params.require(:complaint).permit(:complainant_name, :complainant_address, :complainant_address, :complainant_email, :cemetery_regulated, :cemetery_county, :lot_location, :name_on_deed, :relationship, :ownership_type, :summary, :form_of_relief, :person_contacted, :attorney_contacted, :court_action_pending, :investigation_required)
    end

    def complaint_date_params
      date_params = {}
      [:date_of_event, :date_complained_to_cemetery, :date_acknowledged, :investigation_begin_date, :investigation_completion_date].each do |param|
        if params[:complaint][param] =~ /[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4}/
          date_params[param] = Date.strptime(params[:complaint][param], "%m/%d/%Y", )
        else
          date_params[param] = Date.parse(params[:complaint][param]) rescue nil
        end
      end

      date_params
    end
end
