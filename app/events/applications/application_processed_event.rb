class Applications::ApplicationProcessedEvent < ApplicationEvent
  def event_type
    Type::APPLICATION_PROCESSED
  end
end