class NoteEvent < Event
  class Type
    COMMENT = 'comment'
  end

  attr_accessor :note, :user

  def initialize(note, user)
    self.note = note
    self.user = user
  end

  def payload
    super.merge({
      object: note,
      user: user
    })
  end
end