module ComplaintsHelper
  def cemetery_options
    cemeteries = Cemetery.all
    grouped_cemeteries = []

    COUNTIES.each do |number, name|
      county_cemeteries = []
      cemeteries.where(county: number).order(:order_id).each do |cemetery|
        county_cemeteries << ["#{cemetery.cemetery_id} #{cemetery.name}", cemetery.id]
      end
      grouped_cemeteries << ["#{name} County", county_cemeteries]
    end

    grouped_cemeteries
  end

  def employee_options
    employees = User.where("role > ?", 1)
    grouped_employees = []

    ROLES.each do |id, name|
      # Weed out non-employee roles
      next unless id > 1

      role_employees = []
      employees.where(role: id).each do |employee|
        role_employees << [employee.name, employee.id]
      end
      grouped_employees << [name, role_employees]
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
