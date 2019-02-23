class RulesEvent < Event
  class Type
    APPROVAL = 'approval'
    UPLOAD = 'upload'
  end

  attr_accessor :rules, :user

  def initialize(rules, user)
    self.rules = rules
    self.user = user
  end

  def payload
    super.merge({
      object: rules,
      user: user
    })
  end
end