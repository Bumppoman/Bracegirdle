module NotesHelper
  def note_link(note)
    link_method = 
      note.notable.respond_to?(:concern_link) ?
      note.notable.concern_link :
      ActionDispatch::Routing::PolymorphicRoutes::HelperMethodBuilder.path.handle_model(note.notable)[0]
    notable_text = note.notable.concern_text
    [notable_text[0], link_to(notable_text[1], self.send(link_method, note.notable, anchor: "note-#{note.id}")), notable_text[2]].join(' ').html_safe
  end

  def note_text(note)
    note.notable.concern_text.join(' ')
  end
end
