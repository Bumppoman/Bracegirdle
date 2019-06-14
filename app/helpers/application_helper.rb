module ApplicationHelper
  def active_circle_link(title, path, condition, options = {})
    link_to path, options do
      (title + (condition ? tag.span('', class: 'active-circle') : '')).html_safe
    end
  end

  def active_item(expression)
    "active" if expression
  end

  def breadcrumbs_helper(breadcrumbs)
    html = ''
    html << content_tag(:li, link_to('Dashboard', root_path), class: 'breadcrumb-item')
    breadcrumbs.each do |item|
      case item.class.to_s
      when 'Array'
        string, link = item
        html << content_tag(:li, link_to(string, link), class: "breadcrumb-item #{item.equal?(breadcrumbs.last) ? 'active' : nil}")
      when 'String', 'ActiveSupport::SafeBuffer'
        html << content_tag(:li, item, class: "breadcrumb-item #{item.equal?(breadcrumbs.last) ? 'active' : nil}")
      end
    end
    html.html_safe
  end

  def investigator_inbox_items
    current_user.rules.where.not(status: :revision_requested).count
  end

  def sort_date(date)
    date&.strftime('%Y%m%d')
  end
end
