module BoardApplications
  class AbandonmentController < RestorationsController
    MODEL = Abandonment
    PAGE_INFO = {
      new: {
        title: 'Upload New Abandonment Application',
        breadcrumbs: 'Abandonment applications'
      }
    }.freeze
  end
end