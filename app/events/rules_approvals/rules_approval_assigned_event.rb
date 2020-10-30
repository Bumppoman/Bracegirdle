class RulesApprovals::RulesApprovalAssignedEvent < RulesApprovalEvent
  def event_type
    Type::RULES_APPROVAL_ASSIGNED
  end
end