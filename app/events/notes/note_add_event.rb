class Notes::NoteAddEvent < NoteEvent
  def event_type
    Type::COMMENT
  end

  def payload
    super.merge({
      sender: user.id,
      receiver: note.notable.user.id
    })
  end
end