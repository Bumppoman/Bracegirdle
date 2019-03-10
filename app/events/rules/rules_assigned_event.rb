class Rules::RulesAssignedEvent < RulesEvent
  def event_type
    Type::RULES_ASSIGNED
  end

  def payload
    super.merge({
      assigned: rules.investigator
    })
  end
end