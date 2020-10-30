class RulesApprovals::RulesApprovalRevisionRequestedEvent < RulesApprovalEvent
  def event_type
    Type::RULES_APPROVAL_REVISION_REQUESTED
  end
end