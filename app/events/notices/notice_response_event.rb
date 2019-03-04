class Notices::NoticeResponseEvent < NoticeEvent
  def event_type
    Type::RESPONSE
  end
end