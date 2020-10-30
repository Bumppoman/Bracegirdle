module RulesHelper
  def other_rules(cemetery, current)
    links = []
    Rules.where(cemetery: cemetery).where.not(id: current).order(approval_date: :desc).each do |rules|
      links << link_to(rules.approval_date, 
        rules_by_date_cemetery_path(cemid: cemetery.cemid, date: rules.approval_date.iso8601), 
        class: 'mg-r-5'
      )
    end

    links.empty? ? 'None added.' : links.join(content_tag(:span, ' | ', class: 'mg-l-5 mg-r-10'))
  end
end
