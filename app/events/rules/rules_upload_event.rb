class Rules::RulesUploadEvent < RulesEvent
  def event_type
    Type::UPLOAD
  end
end