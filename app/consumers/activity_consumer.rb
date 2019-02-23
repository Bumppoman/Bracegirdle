class ActivityConsumer < Consumer
  def call
    activity = Activity.new(
      user_id: payload[:user].id,
      model_id: payload[:object].id,
      model_type: payload[:object].class,
      activity_performed: payload[:event_type]
    )

    activity.save
  end
end