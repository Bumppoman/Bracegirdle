# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def note_comment_email
    notification = Notification.last
    configuration = YAML.load_file(Rails.root.join('config', 'notifications.yml'))['notifications'][notification.object_type.downcase][notification.message]
    if configuration.key? 'mailer'
      NotificationMailer.send(configuration['mailer'], notification.receiver.id, notification.id).deliver
    end
  end
end
