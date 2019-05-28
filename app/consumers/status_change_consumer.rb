class StatusChangeConsumer < Consumer
  def call
    # Update current status to reflect leaving
    new_status = payload[:object].class.statuses[payload[:object].status]
    if previous_status = StatusChange.where(statable: payload[:object], left_at: nil).first
      previous_status.update(left_at: Time.now)
    end

    # Create record for new status
    status_change = StatusChange.new(
      statable: payload[:object],
      status: new_status,
      initial: (payload[:object].current_status_is_initial? && previous_status.nil?),
      final: payload[:object].current_status_is_final?
    )

    status_change.save
  end
end