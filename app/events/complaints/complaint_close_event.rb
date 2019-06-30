class Complaints::ComplaintCloseEvent < ComplaintEvent
  def event_type
    Type::COMPLAINT_CLOSED
  end

  def payload
    super.merge({
      assigned: complaint.investigator
    })
  end
end