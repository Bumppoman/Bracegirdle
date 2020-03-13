class Notices::NoticeFollowUpEvent < NoticeEvent
  def event_type
    Type::NOTICE_FOLLOW_UP
  end
end
