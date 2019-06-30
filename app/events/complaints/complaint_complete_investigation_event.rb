class Complaints::ComplaintCompleteInvestigationEvent < ComplaintEvent
  def event_type
    Type::COMPLAINT_INVESTIGATION_COMPLETED
  end

  def payload
    super.merge({
      assigned: complaint.investigator
    })
  end
end