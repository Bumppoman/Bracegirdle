class CemeteryInspections::CemeteryInspectionUploadedEvent < CemeteryInspectionEvent
  def event_type
    Type::CEMETERY_INSPECTION_UPLOADED
  end
end