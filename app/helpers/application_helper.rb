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
    when :reviewed, :scheduled, :approved
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

  def employee_options(selected = nil, roles = [:investigator, :accountant, :support])
    role_employees = User.where(active: true, role: roles).order(:name).group_by(&:role)
    collection = roles.map { |role| OpenStruct.new(name: role.to_s.capitalize, employees: role_employees[role.to_s]) if role_employees[role.to_s] }.reject(&:nil?)
    option_groups_from_collection_for_select(collection, :employees, :name, :id, :name, selected)
  end

  def sort_date(date)
    date&.strftime('%Y-%m-%d')
  end
end
