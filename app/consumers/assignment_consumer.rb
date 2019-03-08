class AssignmentConsumer < NotificationConsumer
  def call
    if payload[:assigned].id != payload[:user].id
      notify(payload[:user].id, payload[:assigned].id)
    end
  end

end