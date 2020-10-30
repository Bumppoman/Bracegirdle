class BoardApplications::BoardApplicationReceivedEvent < BoardApplicationEvent
  def event_type
    Type::BOARD_APPLICATION_RECEIVED
  end

  def payload
    super.merge({
      assigned: board_application.investigator
    })
  end
end