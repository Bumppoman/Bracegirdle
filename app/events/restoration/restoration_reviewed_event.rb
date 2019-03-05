class Restoration::RestorationReviewedEvent < RestorationEvent
  def event_type
    Type::REVIEWED
  end
end