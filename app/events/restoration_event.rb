class RestorationEvent < Event
  class Type
    RECEIVED = 'received'
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