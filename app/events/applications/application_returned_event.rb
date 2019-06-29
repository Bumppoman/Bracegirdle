class Applications::ApplicationReturnedEvent < ApplicationEvent
  def event_type
    Type::APPLICATION_RETURNED
  end
end