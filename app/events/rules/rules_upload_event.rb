class Rules::RulesUploadEvent < RulesEvent
  def event_type
    Type::RULES_UPLOADED
  end

  def payload
    super.merge({
      assigned: rules.investigator
    })
  end
end