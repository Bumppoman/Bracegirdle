class Notices::NoticeResponseEvent < NoticeEvent
  def event_type
    Type::NOTICE_RESPONSE
  end
end