class Notices::NoticeIssueEvent < NoticeEvent
  def event_type
    Type::NOTICE_ISSUED
  end
end