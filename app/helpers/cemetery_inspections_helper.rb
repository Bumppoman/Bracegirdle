module CemeteryInspectionsHelper
  def cemetery_inspection_link(inspection, link_text_method = :date_performed)
    path = (inspection.performed? || inspection.completed?) ? 
      show_inspection_cemetery_path(inspection.cemetery, inspection) : 
      inspect_cemetery_path(inspection.cemetery)

    link_to inspection.send(link_text_method), path
  end
  
  def cemetery_inspection_path(inspection)
    show_inspection_cemetery_path(inspection.cemetery, inspection)
  end
  
  def display_cemetery_inspection_report(inspection)
    if inspection.inspection_report.attached?
      raw_attachment_link(inspection.inspection_report)
    else
      #pdfjs.full_path(file: view_inspection_report_cemetery_path(inspection.cemetery, inspection))
      view_inspection_report_cemetery_path(inspection.cemetery, inspection)
    end
  end

  def download_cemetery_inspection_report_link(inspection)
    if inspection.inspection_report.attached?
      rails_blob_path(inspection.inspection_report, disposition: 'attachment')
    else
      view_inspection_report_cemetery_path(inspection.cemetery, inspection)
    end
  end
  
  def number_of_trustees(trustee_count)
    if trustee_count && trustee_count.nonzero?
      trustee_count
    else
      'Unknown'
    end
  end

  def verbose_cemetery_inspection_status(inspection)
    case inspection.status.to_sym
      when :performed
        'Performed; not yet mailed'
      when :completed
        inspection.legacy? ? 'Completed' : "Completed (mailed #{@inspection.date_mailed})"
    end
  end
end
