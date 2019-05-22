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

      configuration = YAML.load_file(Rails.root.join('config', 'notifications.yml'))['notifications'][notification.object_type.downcase][notification.message]
      if configuration.key? 'mailer'
        #NotificationMailer.send(configuration['mailer'], receiver, notification.id).deliver
      end
    end
  end
end