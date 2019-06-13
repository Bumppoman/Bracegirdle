class Restoration::RestorationReturnedEvent < RestorationEvent
  def event_type
    Type::RESTORATION_RETURNED
  end
end