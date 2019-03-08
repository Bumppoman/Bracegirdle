class Complaints::ComplaintAddEvent < ComplaintEvent
  def event_type
    Type::COMPLAINT_ADDED
  end

  def payload
    super.merge({
      assigned: complaint.investigator
    })
  end
end