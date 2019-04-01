module CemeteriesHelper
  def formatted_last_inspection(cemetery)
    if cemetery.last_inspection
      "#{cemetery.last_inspection_date} (#{link_to 'view', show_inspection_cemetery_path(date: cemetery.last_inspection)})"
    elsif cemetery.last_inspection_date
      cemetery.last_inspection_date
    else
      'No inspection recorded'
    end
  end
end
