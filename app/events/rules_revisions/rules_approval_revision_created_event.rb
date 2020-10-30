class RulesRevisions::RulesApprovalRevisionCreatedEvent < RulesRevisionEvent
  def event_type
    Type::RULES_APPROVAL_REVISION_CREATED
  end
end