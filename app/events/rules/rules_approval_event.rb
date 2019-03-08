class Rules::RulesApprovalEvent < RulesEvent
  def event_type
    Type::RULES_APPROVED
  end
end