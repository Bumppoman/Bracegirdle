class Restoration::RestorationReceivedEvent < RestorationEvent
  def event_type
    Type::RECEIVED
  end

  def payload
    super.merge({
      assigned: restoration.investigator
    })
  end
end