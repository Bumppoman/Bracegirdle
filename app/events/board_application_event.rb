class BoardApplicationEvent < Event
  class Type
    BOARD_APPLICATION_PROCESSED = 'processed'
    BOARD_APPLICATION_RECEIVED = 'received'
    BOARD_APPLICATION_RETURNED = 'returned'
    BOARD_APPLICATION_REVIEWED = 'reviewed'
  end

  attr_accessor :board_application, :user

  def initialize(board_application, user)
    self.board_application = board_application
    self.user = user
  end

  def payload
    super.merge({
      object: board_application,
      user: user
    })
  end
end