module AttachmentsHelper
  def display_attachment(attachment, request)
    if %w(application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document).include? attachment.file.content_type
      <<-ATTACHMENT
        <div 
          class="embed-responsive"
          style="padding-top: 100%; -webkit-overflow-scrolling: touch !important; overflow-y: auto !important; overflow-x: scroll;"
        >
          <object
            class="embed-responsive-item"
            type="#{attachment.file.blob.content_type} %>"
            data="https://view.officeapps.live.com/op/embed.aspx?src=#{request.protocol}#{request.host}#{rails_blob_url attachment.file, only_path: true}"
          ></object>
        </div>
      ATTACHMENT
    elsif attachment.file.content_type == 'application/pdf'
      render partial: 'application/pdf_viewer', locals: { pdf: attachment.file }
    end
  end
  
  def raw_attachment_link(attachment)
    file = case attachment
      when Attachment
         attachment.file
      when ActiveStorage::Attached::One
        attachment
    end
    
    rails_blob_path(file)
  end

  def view_attachment_link(object, attachment)
    if %w(application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document application/pdf image/jpeg).include? attachment.file.content_type
      polymorphic_url([object, attachment])
    else
      rails_blob_path(attachment.file)
    end
  end
end