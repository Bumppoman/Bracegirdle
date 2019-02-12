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
    @rules_count = Rules.pending_review_for(current_user).count
    @rules_count
  end

  def named_region(region)
    NAMED_REGIONS[region]
  end
end
