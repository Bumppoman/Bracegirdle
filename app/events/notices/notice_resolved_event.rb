class Notices::NoticeResolvedEvent < NoticeEvent
  def event_type
    Type::NOTICE_RESOLVED
  end
end
