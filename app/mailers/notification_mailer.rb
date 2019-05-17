class NotificationMailer < ApplicationMailer
  #include NotificationsHelper

  helper NotificationsHelper

  def notification_email(user, notification)
    @user = User.find(user)
    @notification = Notification.find(notification)

    mail(to: @user.email, subject: ApplicationController.render(inline: @notification.text, locals: { notification: @notification }))
  end
end
