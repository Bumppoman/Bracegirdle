EVENT_CONSUMER_MAPPING = {
  ComplaintEvent::Type::COMPLAINT_ADDED => [ActivityConsumer, AssignmentConsumer],
  NoteEvent::Type::COMMENT => [ActivityConsumer, NotificationConsumer],
  NoticeEvent::Type::NOTICE_ISSUED => [ActivityConsumer],
  NoticeEvent::Type::NOTICE_RESPONSE => [ActivityConsumer],
  RestorationEvent::Type::RESTORATION_PROCESSED => [ActivityConsumer, SupervisorConsumer],
  RestorationEvent::Type::RESTORATION_RECEIVED => [ActivityConsumer, AssignmentConsumer],
  RestorationEvent::Type::RESTORATION_REJECTED => [ActivityConsumer, AssignmentConsumer],
  RestorationEvent::Type::RESTORATION_REVIEWED => [ActivityConsumer, NotificationConsumer],
  RulesEvent::Type::RULES_APPROVED => [ActivityConsumer],
  RulesEvent::Type::RULES_ASSIGNED => [ActivityConsumer, AssignmentConsumer],
  RulesEvent::Type::RULES_REVISION_REQUESTED => [ActivityConsumer],
  RulesEvent::Type::RULES_REVISION_RECEIVED => [ActivityConsumer],
  RulesEvent::Type::RULES_UPLOADED => [ActivityConsumer, AssignmentConsumer]
}.freeze

EVENT_CONSUMER_MAPPING.each do |event_name, consumer_list|
  consumer_list.each do |consumer|
    ActiveSupport::Notifications.subscribe(event_name) do |*args|
      consumer.new(args.last).call
    end
  end
end