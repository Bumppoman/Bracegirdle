class Notices::NotesController < NotesController
  before_action :set_notable

  private
    def set_notable
      @notable = Notice.includes(:investigator).find(params[:notice_id])
    end
end