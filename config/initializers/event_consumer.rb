EVENT_CONSUMER_MAPPING = {
  ComplaintEvent::Type::ADD => [ActivityConsumer],
  NoticeEvent::Type::ISSUE => [ActivityConsumer],
  NoticeEvent::Type::RESPONSE => [ActivityConsumer],
  RestorationEvent::Type::PROCESSED => [ActivityConsumer, SupervisorConsumer],
  RestorationEvent::Type::RECEIVED => [ActivityConsumer, AssignmentConsumer],
  RestorationEvent::Type::REJECTED => [ActivityConsumer, AssignmentConsumer],
  RestorationEvent::Type::REVIEWED => [ActivityConsumer],
  RulesEvent::Type::APPROVAL => [ActivityConsumer],
  RulesEvent::Type::UPLOAD => [ActivityConsumer, AssignmentConsumer]
}.freeze

EVENT_CONSUMER_MAPPING.each do |event_name, consumer_list|
  consumer_list.each do |consumer|
    ActiveSupport::Notifications.subscribe(event_name) do |*args|
      consumer.new(args.last).call
    end
  end
end