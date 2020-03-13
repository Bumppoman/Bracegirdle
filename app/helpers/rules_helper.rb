module RulesHelper
  def other_rules(cemetery, current)
    links = []
    Rules.approved.where(cemetery: cemetery).where.not(id: current).order(approval_date: :desc).each do |rules|
      links << link_to(rules.approval_date, rules, class: 'mg-r-5')
    end

    links.empty? ? 'None added.' : links.join(content_tag(:span, ' | ', class: 'mg-l-5 mg-r-10'))
  end

  def rules_link(rules)
    if rules.approved?
      rules_path(rules)
    else
      review_rules_path(rules)
    end
  end
end
