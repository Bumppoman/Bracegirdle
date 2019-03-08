class ActivityConsumer < Consumer
  def call
    activity = Activity.new(
      user: payload[:user],
      object: payload[:object],
      activity_performed: payload[:event_type]
    )


    activity.save
  end
end