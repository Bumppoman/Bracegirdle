class Complaints::ComplaintRequestUpdateEvent < ComplaintEvent
  def event_type
    Type::COMPLAINT_UPDATE_REQUESTED
  end

  def payload
    super.merge({
      assigned: complaint.investigator
    })
  end
end