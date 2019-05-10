class AttachmentsController < ApplicationController
  def create

    # Create the attachment
    @attachment = @attachable.attachments.new(attachment_params)
    @attachment.user = current_user
    @attachment.cemetery = @attachable&.cemetery || nil
    @attachment.save

    # Respond
    respond_to do |m|
      m.js { render partial: 'attachments/new_attachment.js.erb' }
    end
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
  end

  def show
    @attachment = Attachment.find(params[:id])

    @title = 'View Attachment'
    @breadcrumbs = { @attachment.attachable.link_text => @attachment.attachable, 'View attachment' => nil }
  end

  private

  def attachment_params
    params.require(:attachment).permit(:description, :file)
  end
end
