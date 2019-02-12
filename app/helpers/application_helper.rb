module ApplicationHelper
  def active_circle_link(title, path, condition, options = {})
    link_to path, options do
      (title + (condition ? tag.span('', class: 'active-circle') : '')).html_safe
    end
  end

  def active_item(expression)
    "active" if expression
  end

  def investigator_inbox_items
    @pending_items[:rules]
  end

  def named_region(region)
    NAMED_REGIONS[region]
  end

  def sort_date(date)
    date.strftime('%Y%m%d')
  end
end
