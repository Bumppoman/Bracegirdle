class Restoration::RestorationProcessedEvent < RestorationEvent
  def event_type
    Type::RESTORATION_PROCESSED
  end
end