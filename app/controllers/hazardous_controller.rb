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
end