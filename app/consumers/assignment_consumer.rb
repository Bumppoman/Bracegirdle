class AssignmentConsumer < Consumer
  def call
    if payload[:assigned].id != payload[:user].id
      notification = Notification.new(
          sender_id: payload[:user].id,
          receiver_id: payload[:assigned].id,
          model_id: payload[:object].id,
          model_type: payload[:object].class,
          message: payload[:event_type]
      )
      notification.save
    end
  end
end