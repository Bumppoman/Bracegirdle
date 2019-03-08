class RulesEvent < Event
  class Type
    RULES_APPROVED = 'approved'
    RULES_UPLOADED = 'uploaded'
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