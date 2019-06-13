class RestorationEvent < Event
  class Type
    RESTORATION_PROCESSED = 'processed'
    RESTORATION_RECEIVED = 'received'
    RESTORATION_RETURNED = 'returned'
    RESTORATION_REVIEWED = 'reviewed'
  end

  attr_accessor :restoration, :user

  def initialize(restoration, user)
    self.restoration = restoration
    self.user = user
  end

  def payload
    super.merge({
        object: restoration,
        user: user
    })
  end
end