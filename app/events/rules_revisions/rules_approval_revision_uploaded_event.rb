class RulesRevisions::RulesApprovalRevisionUploadedEvent < RulesRevisionEvent
  def event_type
    Type::RULES_APPROVAL_REVISION_UPLOADED
  end
end