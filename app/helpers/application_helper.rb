module ApplicationHelper
  def active_circle_link(title, path, condition, options = {})
    link_to path, options do
      (title + (condition ? tag.span('', class: 'active-circle') : '')).html_safe
    end
  end

  def active_item(expression)
    "active" if expression
  end

  def application_link(application, method = :to_sym, title = nil)
    case application.status.to_sym
    when :received
      path = "process_applications_#{application.send(method).downcase}_path"
    when :processed
      if current_user.supervisor?
        path = "review_applications_#{application.send(method).downcase}_path"
      else
        path = "applications_#{application.send(method).downcase}_path"
      end
    when :reviewed, :approved
      path = "applications_#{application.send(method).downcase}_path"
    end

    if application.has_attribute? :application_type
      link_to (title.nil? ? application : title), self.send(path, application, application_type: application.application_type)
    else
      link_to (title.nil? ? application : title), self.send(path, application)
    end
  end

  def breadcrumbs_helper(breadcrumbs)
    html = content_tag(:li, link_to('Dashboard', root_path), class: 'breadcrumb-item')
    breadcrumbs.each do |item|
      case item
      when Array
        string, link = item
        html << content_tag(:li, link_to(string, link), class: "breadcrumb-item #{item.equal?(breadcrumbs.last) ? 'active' : nil}")
      when String, ActiveSupport::SafeBuffer
        html << content_tag(:li, item, class: "breadcrumb-item #{item.equal?(breadcrumbs.last) ? 'active' : nil}")
      end
    end
    html.html_safe
  end

  def cemetery_options
    county_cemeteries = Cemetery.active.group_by(&:county)
    grouped_cemeteries = []

    county_cemeteries.each do |county, cemeteries|
      grouped_cemeteries << ["#{COUNTIES[county]} County",
                             cemeteries.map {|cemetery| ["#{cemetery.cemetery_id} #{cemetery.name}", cemetery.id]}]
    end

    grouped_cemeteries
  end

  def employee_options
    role_employees = User.where(active: true, role: [:investigator, :accountant, :support]).order(:name).group_by(&:role)
    grouped_employees = []

    role_employees.each do |role, employees|
      grouped_employees << [role.capitalize,
                            employees.map {|employee| [employee.name, employee.id]}]
    end

    grouped_employees
  end

  def sort_date(date)
    date&.strftime('%Y-%m-%d')
  end
end
