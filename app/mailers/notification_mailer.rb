class NotificationMailer < ApplicationMailer
  helper NotificationsHelper

  def note_comment_email(user, notification)
    @user = User.find(user)
    @notification = Notification.find(notification)
    @subject = "#{@notification.sender.name} #{ApplicationController.render(inline: @notification.text, locals: { notification: @notification })}"

    mail(to: @user.email, subject: @subject)
  end
end
