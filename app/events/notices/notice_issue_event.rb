class Notices::NoticeIssueEvent < NoticeEvent
  def event_type
    Type::ISSUE
  end
end