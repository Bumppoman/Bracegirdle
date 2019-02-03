module ComplaintsHelper
  def cemetery_options
    county_cemeteries = Cemetery.all.group_by(&:county)
    grouped_cemeteries = []

    county_cemeteries.each do |county, cemeteries|
      grouped_cemeteries << ["#{COUNTIES[county]} County",
                             cemeteries.map {|cemetery| ["#{cemetery.cemetery_id} #{cemetery.name}", cemetery.id]}]
    end

    grouped_cemeteries
  end

  def employee_options
    role_employees = User.where("role > ?", 1).group_by(&:role)
    grouped_employees = []

    role_employees.each do |role, employees|
      grouped_employees << ["#{ROLES[role]}",
                            employees.map {|employee| [employee.name, employee.id]}]
    end

    grouped_employees
  end

  def formatted_complaint_types(complaint)
    complaint_types = []
    complaint.complaint_type.each do |type|
      complaint_types << Complaint.raw_complaint_types[type.to_i]
    end

    complaint_types.join("<br />").html_safe
  end
end
