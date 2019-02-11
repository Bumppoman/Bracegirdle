module ApplicationHelper
  def active_circle_link(title, path, condition, options = {})
    link_to path, options do
      (title + (condition ? tag.span('', class: 'active-circle') : '')).html_safe
    end
  end

  def active_item(expression)
    "active" if expression
  end

  def format_date_param(param)
    if param =~ /[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4}/
      return Date.strptime(param, "%m/%d/%Y", )
    else
      return Date.parse(param) rescue nil
    end
  end

  def investigator_inbox_items
    @rules ||= Rules.active_for(current_user).count
    @rules
  end

  def named_region(region)
    NAMED_REGIONS[region]
  end
end
