class Restoration::RestorationProcessedEvent < RestorationEvent
  def event_type
    Type::PROCESSED
  end
end