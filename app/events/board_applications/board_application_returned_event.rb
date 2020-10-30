class BoardApplications::BoardApplicationReturnedEvent < BoardApplicationEvent
  def event_type
    Type::BOARD_APPLICATION_RETURNED
  end
end