module RulesHelper
  def rules_display_link(document, request)
    if %w(application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document).include? document.content_type
      "https://view.officeapps.live.com/op/embed.aspx?src=#{request.protocol}#{request.host}#{url_for document}"
    else
      "#{request.protocol}#{request.host}#{url_for document}"
    end
  end
end
