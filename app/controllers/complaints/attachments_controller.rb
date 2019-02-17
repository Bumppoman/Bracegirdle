class Complaints::AttachmentsController < AttachmentsController
  before_action :set_attachable

  private
  def set_attachable
    @attachable = Complaint.find(params[:complaint_id])
  end
end