class Matters::MatterUnscheduledEvent < MatterEvent
  def event_type
    Type::MATTER_UNSCHEDULED
  end

  def payload
    super.merge({
      additional: [matter.application]
    })
  end
end
