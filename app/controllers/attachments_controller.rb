class AttachmentsController < ApplicationController
  def create
    # Create the attachment
    @attachment = @attachable.attachments.includes(:attachable).new(attachment_params)
    @attachment.user = current_user
    @attachment.cemetery = @attachable&.cemetery || nil
    @attachment.save
  end

  def destroy
    @attachment = Attachment.includes(file_attachment: :blob).find(params[:id])
    @attachment.destroy
  end

  def show
    @attachment = Attachment.find(params[:id])
  end

  private

  def attachment_params
    params.require(:attachment).permit(:description, :file)
  end
end
