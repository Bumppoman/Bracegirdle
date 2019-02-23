class Event
  def event_type
    raise NotImplementedError.new("#{self.class.name}#event_type is not implemented.")
  end

  def payload
    {
        event_type: event_type,
        timestamp: DateTime.now,
    }
  end

  def trigger
    ActiveSupport::Notifications.instrument(event_type, payload)
  end
end