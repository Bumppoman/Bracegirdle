class CemeteryInspections::CemeteryInspectionCompletedEvent < CemeteryInspectionEvent
  def event_type
    Type::CEMETERY_INSPECTION_COMPLETED
  end
end