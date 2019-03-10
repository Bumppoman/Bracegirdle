class Rules::RulesRevisionReceivedEvent < RulesEvent
  def event_type
    Type::RULES_REVISION_RECEIVED
  end
end