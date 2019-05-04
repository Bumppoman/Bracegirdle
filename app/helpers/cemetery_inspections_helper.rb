module CemeteryInspectionsHelper
  def inspection_link(inspection)
    if inspection.complete?
      link_to inspection.date_performed, show_inspection_cemetery_path(inspection.cemetery, identifier: inspection)
    elsif !inspection.performed?
      link_to inspection.date_performed, inspect_cemetery_path(inspection.cemetery)
    end
  end
end
