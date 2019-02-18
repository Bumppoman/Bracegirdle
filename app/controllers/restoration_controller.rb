class RestorationController < ApplicationController
  include Permissions

  before_action do
    stipulate :must_be_investigator
  end

  def index
    self.send(params[:type])
  end

  def new
    @application = Restoration.new(application_type: params[:type])

    @title = 'Upload New Application'
    @breadcrumbs = { 'Upload new application' => nil }
  end

  private

  def abandonment
    @applications = Restoration.abandonment

    @title = 'Pending Abandonment Applications'
    @breadcrumbs = { 'Pending abandonment applications' => nil}
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
