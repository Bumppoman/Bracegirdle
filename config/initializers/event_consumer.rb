EVENT_CONSUMER_MAPPING = {
  CemeteryInspectionEvent::Type::CEMETERY_INSPECTION_COMPLETED => [ActivityConsumer],
  ComplaintEvent::Type::COMPLAINT_ADDED => [ActivityConsumer, AssignmentConsumer, StatusChangeConsumer],
  NoteEvent::Type::COMMENT => [ActivityConsumer, NotificationConsumer],
  NoticeEvent::Type::NOTICE_ISSUED => [ActivityConsumer, StatusChangeConsumer],
  NoticeEvent::Type::NOTICE_RESPONSE => [ActivityConsumer, StatusChangeConsumer],
  ApplicationEvent::Type::APPLICATION_PROCESSED => [ActivityConsumer, SupervisorConsumer, StatusChangeConsumer],
  ApplicationEvent::Type::APPLICATION_RECEIVED => [ActivityConsumer, AssignmentConsumer, StatusChangeConsumer],
  ApplicationEvent::Type::APPLICATION_RETURNED=> [ActivityConsumer, AssignmentConsumer],
  ApplicationEvent::Type::APPLICATION_REVIEWED => [ActivityConsumer, NotificationConsumer, StatusChangeConsumer],
  RulesEvent::Type::RULES_APPROVED => [ActivityConsumer, StatusChangeConsumer],
  RulesEvent::Type::RULES_ASSIGNED => [ActivityConsumer, AssignmentConsumer, StatusChangeConsumer],
  RulesEvent::Type::RULES_REVISION_REQUESTED => [ActivityConsumer, StatusChangeConsumer],
  RulesEvent::Type::RULES_REVISION_RECEIVED => [ActivityConsumer, StatusChangeConsumer],
  RulesEvent::Type::RULES_UPLOADED => [ActivityConsumer, AssignmentConsumer, StatusChangeConsumer]
}.freeze

EVENT_CONSUMER_MAPPING.each do |event_name, consumer_list|
  consumer_list.each do |consumer|
    ActiveSupport::Notifications.subscribe(event_name) do |*args|
      consumer.new(args.last).call
    end
  end
end