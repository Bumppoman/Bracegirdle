class AttachmentsController < ApplicationController
  def create

    # Create the attachment
    @attachment = @attachable.attachments.new(attachment_params)
    @attachment.update(user: current_user, cemetery: @attachable.cemetery)

    # Respond
    respond_to do |m|
      m.js { render partial: 'attachments/new_attachment.js.erb' }
    end
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
  end

  private

  def attachment_params
    params.require(:attachment).permit(:description, :file)
  end
end
