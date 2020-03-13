class StatusChangeConsumer < Consumer
  def call
    time = Time.now

    # Merge any additional objects
    objects = [payload[:object]]
    objects += payload[:additional] if payload.key? :additional

    objects.each do |object|
      # Update current status to reflect leaving
      new_status = object.class.statuses[object.status]
      if previous_status = StatusChange.where(statable: object, left_at: nil).first
        previous_status.update(left_at: time)
      end

      # Create record for new status
      status_change = StatusChange.new(
        statable: object,
        status: new_status,
        initial: (object.current_status_is_initial? && previous_status.nil?),
        final: object.current_status_is_final?,
        created_at: time
      )

      status_change.save
    end
  end
end
