class Complaints::ComplaintAssignEvent < ComplaintEvent
  def event_type
    Type::COMPLAINT_ASSIGNED
  end

  def payload
    super.merge({
      assigned: complaint.investigator
    })
  end
end