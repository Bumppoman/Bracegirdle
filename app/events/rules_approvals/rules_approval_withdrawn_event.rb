class RulesApprovals::RulesApprovalWithdrawnEvent < RulesApprovalEvent
  def event_type
    Type::RULES_APPROVAL_WITHDRAWN
  end
end