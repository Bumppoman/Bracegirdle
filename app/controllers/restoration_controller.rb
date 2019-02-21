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
      type = params[:type].to_sym
      @title = PAGE_INFO[type][:new][:title]
      @breadcrumbs = { PAGE_INFO[type][:new][:breadcrumbs] => restoration_index_path(type: params[:type]), 'Upload new application' => nil }

      render :new
    end
  end

  def index
    self.send(params[:type])
  end

  def new
    type = params[:type].to_sym
    @restoration = Restoration.new(application_type: type)

    @title = PAGE_INFO[type][:new][:title]
    @breadcrumbs = { PAGE_INFO[type][:new][:breadcrumbs] => restoration_index_path(type: params[:type]), 'Upload new application' => nil }
  end

  private

  def abandonment
    @applications = Restoration.abandonment

    @title = 'Pending Abandonment Applications'
    @breadcrumbs = { 'Pending abandonment applications' => nil}
  end

  def application_create_params
    params.require(:restoration).permit(:amount, :cemetery, :cemetery_county, :trustee, :submission_date, :raw_application_file)
  end

  def hazardous
    @applications = Restoration.hazardous

    @title = 'Pending Hazardous Monuments Applications'
    @breadcrumbs = { 'Pending hazardous applications' => nil}
  end

  def vandalism
    @applications = Restoration.vandalism

    @title = 'Pending Vandalism Applications'
    @breadcrumbs = { 'Pending vandalism applications' => nil}
  end
end
