class ApplicationEvent < Event
  class Type
    APPLICATION_PROCESSED = 'processed'
    APPLICATION_RECEIVED = 'received'
    APPLICATION_RETURNED = 'returned'
    APPLICATION_REVIEWED = 'reviewed'
  end

  attr_accessor :application, :user

  def initialize(application, user)
    self.application = application
    self.user = user
  end

  def payload
    super.merge({
      object: application,
      user: user
    })
  end
end