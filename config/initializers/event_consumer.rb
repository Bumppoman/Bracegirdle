Rails.application.reloader.to_prepare do
  EVENT_CONSUMER_MAPPING = {
    BoardApplicationEvent::Type::BOARD_APPLICATION_EVALUATED => [ActivityConsumer, SupervisorConsumer, StatusChangeConsumer],
    BoardApplicationEvent::Type::BOARD_APPLICATION_RECEIVED => [ActivityConsumer, AssignmentConsumer, StatusChangeConsumer],
    BoardApplicationEvent::Type::BOARD_APPLICATION_RETURNED=> [ActivityConsumer, AssignmentConsumer],
    BoardApplicationEvent::Type::BOARD_APPLICATION_REVIEWED => [ActivityConsumer, MatterConsumer, NotificationConsumer, StatusChangeConsumer],
    CemeteryInspectionEvent::Type::CEMETERY_INSPECTION_BEGUN => [StatusChangeConsumer],
    CemeteryInspectionEvent::Type::CEMETERY_INSPECTION_COMPLETED => [ActivityConsumer, StatusChangeConsumer],
    CemeteryInspectionEvent::Type::CEMETERY_INSPECTION_STATUS_CHANGED => [StatusChangeConsumer],
    CemeteryInspectionEvent::Type::CEMETERY_INSPECTION_UPLOADED => [StatusChangeConsumer],
    ComplaintEvent::Type::COMPLAINT_ADDED => [ActivityConsumer, AssignmentConsumer, StatusChangeConsumer],
    ComplaintEvent::Type::COMPLAINT_ASSIGNED => [ActivityConsumer, AssignmentConsumer, StatusChangeConsumer],
    ComplaintEvent::Type::COMPLAINT_CLOSED => [ActivityConsumer, StatusChangeConsumer],
    ComplaintEvent::Type::COMPLAINT_CLOSURE_RECOMMENDED => [ActivityConsumer, StatusChangeConsumer, SupervisorConsumer],
    ComplaintEvent::Type::COMPLAINT_INVESTIGATION_BEGUN => [ActivityConsumer, StatusChangeConsumer],
    ComplaintEvent::Type::COMPLAINT_INVESTIGATION_COMPLETED => [ActivityConsumer, StatusChangeConsumer],
    ComplaintEvent::Type::COMPLAINT_REASSIGNED => [ActivityConsumer, AssignmentConsumer, StatusChangeConsumer],
    ComplaintEvent::Type::COMPLAINT_UPDATE_REQUESTED => [ActivityConsumer, AssignmentConsumer],
    MatterEvent::Type::MATTER_SCHEDULED => [StatusChangeConsumer],
    MatterEvent::Type::MATTER_UNSCHEDULED => [StatusChangeConsumer],
    NoteEvent::Type::COMMENT => [ActivityConsumer, NotificationConsumer],
    NoticeEvent::Type::NOTICE_ISSUED => [ActivityConsumer, StatusChangeConsumer],
    NoticeEvent::Type::NOTICE_FOLLOW_UP => [ActivityConsumer, StatusChangeConsumer],
    NoticeEvent::Type::NOTICE_RESOLVED => [ActivityConsumer, StatusChangeConsumer],
    NoticeEvent::Type::NOTICE_RESPONSE => [ActivityConsumer, StatusChangeConsumer],
    RulesApprovalEvent::Type::RULES_APPROVAL_APPROVAL_RECOMMENDED => [ActivityConsumer, StatusChangeConsumer, SupervisorConsumer],
    RulesApprovalEvent::Type::RULES_APPROVAL_APPROVED => [ActivityConsumer, StatusChangeConsumer],
    RulesApprovalEvent::Type::RULES_APPROVAL_ASSIGNED => [ActivityConsumer, AssignmentConsumer, StatusChangeConsumer],
    RulesApprovalEvent::Type::RULES_APPROVAL_REVISION_RECEIVED => [ActivityConsumer, StatusChangeConsumer],
    RulesApprovalEvent::Type::RULES_APPROVAL_REVISION_REQUESTED => [ActivityConsumer, StatusChangeConsumer],
    RulesApprovalEvent::Type::RULES_APPROVAL_UPLOADED => [ActivityConsumer, AssignmentConsumer, StatusChangeConsumer],
    RulesApprovalEvent::Type::RULES_APPROVAL_WITHDRAWN => [ActivityConsumer, StatusChangeConsumer],
    RulesRevisionEvent::Type::RULES_APPROVAL_REVISION_CREATED => [StatusChangeConsumer],
    RulesRevisionEvent::Type::RULES_APPROVAL_REVISION_UPLOADED => [StatusChangeConsumer],
  }.freeze

  EVENT_CONSUMER_MAPPING.each do |event_name, consumer_list|
    consumer_list.each do |consumer|
      ActiveSupport::Notifications.subscribe(event_name) do |*args|
        consumer.new(args.last).call
      end
    end
  end
end