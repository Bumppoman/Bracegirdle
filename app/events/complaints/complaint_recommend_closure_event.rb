class Complaints::ComplaintRecommendClosureEvent < ComplaintEvent
  def event_type
    Type::COMPLAINT_CLOSURE_RECOMMENDED
  end

  def payload
    super.merge({
      assigned: complaint.investigator
    })
  end
end