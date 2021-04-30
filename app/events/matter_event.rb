class MatterEvent < Event
  class Type
    MATTER_CREATED = 'created'
    MATTER_SCHEDULED = 'scheduled'
    MATTER_UNSCHEDULED = 'unscheduled'
  end

  attr_accessor :matter, :user

  def initialize(matter, user)
    self.matter = matter
    self.user = user
  end

  def payload
    super.merge({
      object: matter,
      user: user
    })
  end
end
