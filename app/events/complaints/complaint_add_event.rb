class Complaints::ComplaintAddEvent < ComplaintEvent
  def event_type
    Type::ADD
  end

  def payload
    super.merge({
      assigned: complaint.investigator
    })
  end
end