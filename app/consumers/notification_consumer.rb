class NotificationConsumer < Consumer
  def call
    notify(payload[:sender], payload[:receiver])
  end

  protected

  def notify(sender, receiver)
    notification = Notification.new(
        sender_id: sender,
        receiver_id: receiver,
        object: payload[:object],
        message: payload[:event_type]
    )

    notification.save
  end
end