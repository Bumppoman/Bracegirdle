class RestorationController < ApplicationController
  include Permissions

  before_action do
    stipulate :must_be_investigator
  end

  PAGE_INFO = {
    hazardous: {
      new: {
        title: 'Upload New Abandonment Application',
        breadcrumbs: {
          'Abandonment applications' => Rails.application.routes.url_helpers.restoration_index_path(type: :abandonment),
          'Upload new application' => nil
        }
      }
    },
    hazardous: {
      new: {
        title: 'Upload New Hazardous Monuments Application',
        breadcrumbs: {
          'Hazardous monuments applications' => Rails.application.routes.url_helpers.restoration_index_path(type: :hazardous),
          'Upload new application' => nil
        }
      }
    },
    vandalism: {
      new: {
        title: 'Upload New Vandalism Application',
        breadcrumbs: {
          'Vandalism applications' => Rails.application.routes.url_helpers.restoration_index_path(type: :vandalism),
          'Upload new application' => nil
        }
      }
    }
  }.freeze

  def index
    self.send(params[:type])
  end

  def new
    type = params[:type].to_sym
    @application = Restoration.new(application_type: type)

    @title = PAGE_INFO[type][:new][:title]
    @breadcrumbs = PAGE_INFO[type][:new][:breadcrumbs]
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
