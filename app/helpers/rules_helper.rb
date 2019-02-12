module RulesHelper
  def other_rules(cemetery, current)
    links = []
    Rules.approved.where(cemetery: cemetery).where.not(id: current).order(approval_date: :desc).each do |rules|
      links << link_to(rules.approval_date, rules, class: 'mg-r-5')
    end

    links.empty? ? 'None added.' : links.join(content_tag(:span, ' | ', class: 'mg-l-5 mg-r-10'))
  end

  def rules_display_link(document, request)
    if %w(application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document).include? document.content_type
      "https://view.officeapps.live.com/op/embed.aspx?src=#{request.protocol}#{request.host}#{url_for document}"
    else
      "#{request.protocol}#{request.host}#{url_for document}"
    end
  end
end
