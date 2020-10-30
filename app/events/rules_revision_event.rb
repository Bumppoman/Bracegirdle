class RulesRevisionEvent < Event
  class Type
    RULES_APPROVAL_REVISION_CREATED = 'revision_created'
    RULES_APPROVAL_REVISION_UPLOADED = 'revision_uploaded'
  end

  attr_accessor :revision, :user

  def initialize(revision, user)
    self.revision = revision
    self.user = user
  end

  def payload
    super.merge({
      object: revision,
      user: user
    })
  end
end