class MatterConsumer < Consumer
  def call
    # Determine if the matter already exists
    unless matter = Matter.find_by(board_application: payload[:object])
      # Create the matter
      matter = Matter.create(
        board_application: payload[:object]
      )
    end

    # Trigger the status change consumer
    StatusChangeConsumer.new({ object: matter }).call
  end
end
