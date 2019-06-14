module CemeteryInspectionsHelper
  def display_cemetery_inspection_report(inspection, request)
    if inspection.inspection_report.attached?
      attachment_display_link(inspection.inspection_report, request)
    else
      pdfjs.full_path(file: view_inspection_report_cemetery_path(inspection.cemetery, inspection))
    end
  end

  def download_cemetery_inspection_report_link(inspection)
    if inspection.inspection_report.attached?
      rails_blob_path(inspection.inspection_report, disposition: 'attachment')
    else
      view_inspection_report_cemetery_path(inspection.cemetery, inspection)
    end
  end

  def cemetery_inspection_link(inspection, link_text_method = :date_performed)
    path = (inspection.performed? || inspection.complete?) ? show_inspection_cemetery_path(inspection.cemetery, inspection) : inspect_cemetery_path(inspection.cemetery)
    link_to inspection.send(link_text_method), path
  end

  def verbose_cemetery_inspection_status(inspection)
    case inspection.status.to_sym
    when :performed
      'Performed; not yet mailed'
    when :complete
      "Complete (mailed #{@inspection.date_mailed})"
    end
  end
end
