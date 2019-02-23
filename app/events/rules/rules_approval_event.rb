class Rules::RulesApprovalEvent < RulesEvent
  def event_type
    Type::APPROVAL
  end
end