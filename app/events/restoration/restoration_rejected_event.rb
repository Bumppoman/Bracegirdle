class Restoration::RestorationRejectedEvent < RestorationEvent
  def event_type
    Type::REJECTED
  end
end