module Applications
  class HazardousController < RestorationController
    MODEL = Hazardous
    PAGE_INFO = {
      new: {
        title: 'Upload New Hazardous Monuments Application',
        breadcrumbs: 'Hazardous monuments applications'
      },
      report: {
        class: Reports::HazardousReportPdf
      }
    }.freeze

    private

    def creation_success_path(application)
      applications_hazardous_path(application)
    end
  end
end