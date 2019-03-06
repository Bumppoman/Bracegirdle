class NotificationsController < ApplicationController
  def mark_read
    @notification = Notification.find(params[:id])
    @notification.update(read: true)

    @unread = Notification.for_user(current_user).unread.any?

    respond_to do |m|
      m.js
    end
  end
end
