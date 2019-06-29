module Applications
  class LandController < ApplicationsController
    include Permissions

    CREATION_EVENT = Applications::ApplicationReceivedEvent
    MODEL = Land

    def index
      @applications = Land.send("active_#{params[:application_type].pluralize}_for", current_user)
    end

    def new
      @application = Land.new(application_type: params[:application_type].to_sym)
    end

    def show
    end

    private

    def creation_success_path(application)
      applications_land_path(application, application_type: application.application_type)
    end
  end
end