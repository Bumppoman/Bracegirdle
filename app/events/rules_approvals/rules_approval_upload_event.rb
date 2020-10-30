class RulesApprovals::RulesApprovalUploadEvent < RulesApprovalEvent
  def event_type
    Type::RULES_APPROVAL_UPLOADED
  end

  def payload
    super.merge({
      assigned: rules_approval.investigator
    })
  end
end