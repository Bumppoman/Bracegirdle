class Applications::ApplicationReceivedEvent < ApplicationEvent
  def event_type
    Type::APPLICATION_RECEIVED
  end

  def payload
    super.merge({
      assigned: application.investigator
    })
  end
end