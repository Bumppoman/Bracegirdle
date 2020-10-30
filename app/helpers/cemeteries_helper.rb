module CemeteriesHelper
  def formatted_last_audit(cemetery)
    if cemetery.last_audit_date
      output = cemetery.last_audit_date.to_s
    else
      output = 'No audit recorded'
    end

    output
  end

  def formatted_last_inspection(cemetery)
    if cemetery.last_inspection_date
      output = cemetery.last_inspection_date.to_s
      output << " (#{link_to 'view', show_inspection_cemetery_path(identifier: cemetery.last_inspection)})" if cemetery.last_inspection
    else
      output = 'No inspection recorded'
    end

    raw output
  end
end
