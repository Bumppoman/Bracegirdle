class Complaints::ComplaintBeginInvestigationEvent < ComplaintEvent
  def event_type
    Type::COMPLAINT_INVESTIGATION_BEGUN
  end

  def payload
    super.merge({
      assigned: complaint.investigator
    })
  end
end