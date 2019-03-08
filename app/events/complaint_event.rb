class ComplaintEvent < Event
  class Type
    COMPLAINT_ADDED = 'added'
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