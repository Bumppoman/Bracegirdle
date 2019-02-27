class Restoration::RestorationReceivedEvent < RestorationEvent
  def event_type
    Type::RECEIVED
  end
end