class Complaints::ComplaintReassignEvent < ComplaintEvent
  def event_type
    Type::COMPLAINT_REASSIGNED
  end

  def payload
    super.merge({
      assigned: complaint.investigator
    })
  end
end