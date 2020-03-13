class Matters::MatterScheduledEvent < MatterEvent
  def event_type
    Type::MATTER_SCHEDULED
  end

  def payload
    super.merge({
      additional: [matter.application]
    })
  end
end
