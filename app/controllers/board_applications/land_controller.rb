module BoardApplications
  class LandController < BoardApplicationsController
    CREATION_EVENT = BoardApplications::BoardApplicationReceivedEvent
    MODEL = Land
    PAGE_INFO = {
      new: {
        title: "Upload New Land Application",
        breadcrumbs: 'Land applications'
      },
      report: {
        #class: Reports::HazardousReportPDF
      }
    }.freeze

    def index
      if ['purchase', 'sale'].include?(params[:application_type])
        application_type = params[:application_type].pluralize
      else
        raise Exception
      end
      
      @board_applications = Land.send("active_#{application_type}_for", current_user)
    end

    def new
      @board_application = Land.new(application_type: params[:application_type].to_sym)
    end

    def show
    end

    private

    def creation_success_path(application)
      board_applications_land_path(application, application_type: application.application_type)
    end
  end
end
