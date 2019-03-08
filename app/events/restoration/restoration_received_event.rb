class Restoration::RestorationReceivedEvent < RestorationEvent
  def event_type
    Type::RESTORATION_RECEIVED
  end

  def payload
    super.merge({
      assigned: restoration.investigator
    })
  end
end