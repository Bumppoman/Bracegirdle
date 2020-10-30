class BoardApplications::BoardApplicationReviewedEvent < BoardApplicationEvent
  def event_type
    Type::BOARD_APPLICATION_REVIEWED
  end
end