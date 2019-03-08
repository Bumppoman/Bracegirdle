class AssignmentConsumer < NotificationConsumer
  def call
    notify(payload[:user].id, payload[:assigned].id)
  end

end