class CemeteryInspections::CemeteryInspectionStatusChangedEvent < CemeteryInspectionEvent
  def event_type
    Type::CEMETERY_INSPECTION_STATUS_CHANGED
  end
end