class Complaints::ComplaintAddEvent < ComplaintEvent
  def event_type
    Type::ADD
  end
end