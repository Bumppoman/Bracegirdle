class Restoration::RestorationReviewedEvent < RestorationEvent
  def event_type
    Type::RESTORATION_REVIEWED
  end
end