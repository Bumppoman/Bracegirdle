class CemeteryInspectionEvent < Event
  class Type
    CEMETERY_INSPECTION_BEGUN = 'begun'
    CEMETERY_INSPECTION_COMPLETED = 'completed'
    CEMETERY_INSPECTION_STATUS_CHANGED = 'status_changed'
    CEMETERY_INSPECTION_UPLOADED = 'uploaded'
  end

  attr_accessor :inspection, :user

  def initialize(inspection, user)
    self.inspection = inspection
    self.user = user
  end

  def payload
    super.merge({
      object: inspection,
      user: user
  })
  end
end