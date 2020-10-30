module BoardApplications
  class HazardousController < RestorationsController
    MODEL = Hazardous
    PAGE_INFO = {
      new: {
        title: 'Upload New Hazardous Monuments Application',
        breadcrumbs: 'Hazardous monuments applications'
      },
      report: {
        class: Reports::HazardousReportPDF
      }
    }.freeze

    private

    def creation_success_path(board_application)
      board_applications_hazardous_path(board_application)
    end
  end
end
