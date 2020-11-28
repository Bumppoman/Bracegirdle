class NotesController < ApplicationController
  def create

    # Create the note
    @note = @notable.notes.new note_params
    @note.user = current_user

    @body = @note.body.gsub(/(?:\n\r?|\r\n?)/, '<br>').html_safe

    # Save the note
    @note.save
    Notes::NoteAddEvent.new(@note, current_user).trigger
  end

  private
    def note_params
      params.require(:note).permit(:body)
    end
end
