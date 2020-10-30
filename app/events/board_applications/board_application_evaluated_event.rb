class BoardApplications::BoardApplicationEvaluatedEvent < BoardApplicationEvent
  def event_type
    Type::BOARD_APPLICATION_PROCESSED
  end
end