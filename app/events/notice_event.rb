class NoticeEvent < Event
  class Type
    NOTICE_ISSUED = 'issued'
    NOTICE_RESPONSE = 'response'
    NOTICE_FOLLOW_UP = 'follow_up'
    NOTICE_RESOLVED = 'resolved'
  end

  attr_accessor :notice, :user

  def initialize(notice, user)
    self.notice = notice
    self.user = user
  end

  def payload
    super.merge({
      object: notice,
      user: user
    })
  end
end
