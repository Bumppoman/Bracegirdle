class RulesApprovals::RulesApprovalApprovedEvent < RulesApprovalEvent
  def event_type
    Type::RULES_APPROVAL_APPROVED
  end
end