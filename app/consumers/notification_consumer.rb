class NotificationConsumer < Consumer
  def call
    notify(payload[:sender], payload[:receiver])
  end

  protected

  def notify(sender, receiver)
    if sender != receiver
      notification = Notification.new(
          sender_id: sender,
          receiver_id: receiver,
          object: payload[:object],
          message: payload[:event_type]
      )
      notification.save

      NotificationMailer.notification_email(receiver, notification.id).deliver
    end
  end
end