module BoardApplications
  class VandalismController < RestorationsController
    MODEL = Vandalism
    PAGE_INFO = {
      new: {
        title: 'Upload New Vandalism Application',
        breadcrumbs: 'Vandalism applications'
      }
    }.freeze
  end
end