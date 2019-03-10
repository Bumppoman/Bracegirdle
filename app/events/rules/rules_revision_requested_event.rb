class Rules::RulesRevisionRequestedEvent < RulesEvent
  def event_type
    Type::RULES_REVISION_REQUESTED
  end
end