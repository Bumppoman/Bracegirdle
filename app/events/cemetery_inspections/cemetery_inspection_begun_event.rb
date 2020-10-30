class CemeteryInspections::CemeteryInspectionBegunEvent < CemeteryInspectionEvent
  def event_type
    Type::CEMETERY_INSPECTION_BEGUN
  end
end