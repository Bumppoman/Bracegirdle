module NotesHelper
  def note_link(note)
    link_method = ActionDispatch::Routing::PolymorphicRoutes::HelperMethodBuilder.path.handle_model(note.notable)[0]
    notable_text = note.notable.concern_text
    [notable_text[0], link_to(notable_text[1], self.send(link_method, note.notable, anchor: "note-#{note.id}")), notable_text[2]].join(' ').html_safe
  end
end
