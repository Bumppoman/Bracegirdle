class BoardApplications::BoardApplicationEvaluatedEvent < BoardApplicationEvent
  def event_type
    Type::BOARD_APPLICATION_EVALUATED
  end
end