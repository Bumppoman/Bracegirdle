class Rules::RulesUploadEvent < RulesEvent
  def event_type
    Type::UPLOAD
  end

  def payload
    super.merge({
      assigned: rules.investigator
    })
  end
end