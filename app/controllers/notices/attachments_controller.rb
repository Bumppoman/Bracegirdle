class Notices::AttachmentsController < AttachmentsController
  before_action :set_attachable

  private
  def set_attachable
    @attachable = Notice.find(params[:notice_id])
  end
end