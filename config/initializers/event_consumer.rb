EVENT_CONSUMER_MAPPING = {
  ComplaintEvent::Type::ADD => [ActivityConsumer],
  NoticeEvent::Type::ISSUE => [ActivityConsumer],
  NoticeEvent::Type::RESPONSE => [ActivityConsumer],
  RestorationEvent::Type::RECEIVED => [ActivityConsumer, AssignmentConsumer],
  RulesEvent::Type::APPROVAL => [ActivityConsumer],
  RulesEvent::Type::UPLOAD => [ActivityConsumer]
}.freeze

EVENT_CONSUMER_MAPPING.each do |event_name, consumer_list|
  consumer_list.each do |consumer|
    ActiveSupport::Notifications.subscribe(event_name) do |*args|
      consumer.new(args.last).call
    end
  end
end