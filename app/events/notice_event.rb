class NoticeEvent < Event
  class Type
    ISSUE = 'issue'
    RESPONSE = 'response'
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