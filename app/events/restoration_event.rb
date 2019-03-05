class RestorationEvent < Event
  class Type
    PROCESSED = 'processed'
    RECEIVED = 'received'
    REJECTED = 'rejected'
    REVIEWED = 'reviewed'
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