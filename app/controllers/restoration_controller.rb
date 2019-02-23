class RestorationController < ApplicationController
  include Permissions

  before_action do
    stipulate :must_be_investigator
  end

  PAGE_INFO = {
    abandonment: {
      new: {
        title: 'Upload New Abandonment Application',
        breadcrumbs: 'Abandonment applications'
      }
    },
    hazardous: {
      new: {
        title: 'Upload New Hazardous Monuments Application',
        breadcrumbs: 'Hazardous monuments applications'
      }
    },
    vandalism: {
      new: {
        title: 'Upload New Vandalism Application',
        breadcrumbs: 'Vandalism applications'
      }
    }
  }.freeze

  def create
    @restoration = Restoration.new(application_create_params)
    @restoration.application_type = params[:type]

    if @restoration.save
    else
      render :new
    end
  end

  def index
    self.send(params[:type])
    render params[:type]
  end

  def new
    @type = params[:type].to_sym
    @restoration = Restoration.new(application_type: @type)
    @page_info = PAGE_INFO[@type]
  end

  private

  def abandonment
    @applications = Restoration.abandonment
  end

  def application_create_params
    params.require(:restoration).permit(:amount, :cemetery, :cemetery_county, :trustee, :submission_date, :raw_application_file)
  end

  def hazardous
    @applications = Restoration.hazardous
  end

  def vandalism
    @applications = Restoration.vandalism
  end
end
