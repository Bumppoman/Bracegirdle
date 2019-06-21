class CemeteryInspections::AttachmentsController < AttachmentsController
  before_action :set_attachable

  private
  def set_attachable
    @attachable = CemeteryInspection.find_by(identifier: params[:cemetery_inspection_id])
  end
end