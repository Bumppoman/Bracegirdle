class AbandonmentController < RestorationController
  MODEL = Abandonment
  PAGE_INFO = {
    new: {
      title: 'Upload New Abandonment Application',
      breadcrumbs: 'Abandonment applications'
    }
  }.freeze
end