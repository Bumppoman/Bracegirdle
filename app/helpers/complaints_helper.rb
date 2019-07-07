module ComplaintsHelper
  def complaint_assignment_options

  end

  def formatted_address(complaint)
    address = ''
    address << "#{complaint.complainant_street_address}<br />" if complaint.complainant_street_address.present?
    address << "#{complaint.complainant_city}, #{complaint.complainant_state}" if complaint.complainant_city.present?
    address << " #{complaint.complainant_zip}" if complaint.complainant_zip.present?
    address
  end

  def formatted_complaint_types(complaint)
    complaint_types = []
    complaint.complaint_type.each do |type|
      complaint_types << Complaint.raw_complaint_types[type.to_i]
    end

    complaint_types.join("<br />").html_safe
  end

  def formatted_ownership(complaint)
    # Return empty string if not provided
    return nil if complaint.name_on_deed.blank?

    return_string = "Owned by #{complaint.name_on_deed}"
    return_string += " (#{complaint.relationship})" if complaint.relationship.present?
    return_string
  end
end
