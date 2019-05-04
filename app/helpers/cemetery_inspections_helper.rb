module CemeteryInspectionsHelper
  def display_inspection_report(inspection, request)
    if inspection.inspection_report.attached?
      attachment_display_link(inspection.inspection_report, request)
    else
      pdfjs.full_path(file: view_inspection_report_cemetery_path(inspection.cemetery, inspection))
    end
  end

  def download_inspection_report_link(inspection)
    if inspection.inspection_report.attached?
      rails_blob_path(inspection.inspection_report, disposition: 'attachment')
    else
      view_inspection_report_cemetery_path(inspection.cemetery, inspection)
    end
  end

  def inspection_link(inspection)
    if !inspection.performed?
      link_to inspection.date_performed, inspect_cemetery_path(inspection.cemetery)
    else
      link_to inspection.date_performed, show_inspection_cemetery_path(inspection.cemetery, identifier: inspection)
    end
  end
end
