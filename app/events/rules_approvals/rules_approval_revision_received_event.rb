class RulesApprovals::RulesApprovalRevisionReceivedEvent < RulesApprovalEvent
  def event_type
    Type::RULES_APPROVAL_REVISION_RECEIVED
  end
end