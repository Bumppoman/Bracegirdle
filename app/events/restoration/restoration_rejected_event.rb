class Restoration::RestorationRejectedEvent < RestorationEvent
  def event_type
    Type::RESTORATION_REJECTED
  end
end