class ComplaintEvent < Event
  class Type
    COMPLAINT_ADDED = 'added'
    COMPLAINT_ASSIGNED = 'assigned'
    COMPLAINT_CLOSED = 'closed'
    COMPLAINT_CLOSURE_RECOMMENDED = 'closure_recommended'
    COMPLAINT_INVESTIGATION_BEGUN = 'investigation_begun'
    COMPLAINT_INVESTIGATION_COMPLETED = 'investigation_completed'
    COMPLAINT_REASSIGNED = 'reassigned'
    COMPLAINT_REOPENED = 'reopened'
    COMPLAINT_UPDATE_REQUESTED = 'update_requested'
  end

  attr_accessor :complaint, :user

  def initialize(complaint, user)
    self.complaint = complaint
    self.user = user
  end

  def payload
    super.merge({
      object: complaint,
      user: user
    })
  end
end