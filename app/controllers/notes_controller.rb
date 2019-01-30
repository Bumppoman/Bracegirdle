class NotesController < ApplicationController
  def create

    # Create the note
    @note = @notable.notes.new note_params
    @note.user = current_user

    # Save the note
    @note.save

    # Respond
    respond_to do |m|
      m.js
    end
  end

  private
    def note_params
      params.require(:note).permit(:body)
    end
end
