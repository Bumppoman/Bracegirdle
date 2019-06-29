class Applications::ApplicationReviewedEvent < ApplicationEvent
  def event_type
    Type::APPLICATION_REVIEWED
  end
end