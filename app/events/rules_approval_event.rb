class RulesApprovalEvent < Event
  class Type
    RULES_APPROVAL_APPROVAL_RECOMMENDED = 'approval_recommended'
    RULES_APPROVAL_APPROVED = 'approved'
    RULES_APPROVAL_ASSIGNED = 'assigned'
    RULES_APPROVAL_REVISION_RECEIVED = 'revision_received'
    RULES_APPROVAL_REVISION_REQUESTED = 'revision_requested'
    RULES_APPROVAL_UPLOADED = 'uploaded'
    RULES_APPROVAL_WITHDRAWN = 'withdrawn'
  end

  attr_accessor :rules_approval, :user

  def initialize(rules_approval, user)
    self.rules_approval = rules_approval
    self.user = user
  end

  def payload
    super.merge({
      object: rules_approval,
      user: user
    })
  end
end