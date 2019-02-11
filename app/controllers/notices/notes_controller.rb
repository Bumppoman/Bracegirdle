class Notices::NotesController < NotesController
  before_action :set_notable

  private
    def set_notable
      @notable = Notice.find(params[:notice_id])
    end
end