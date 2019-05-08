class CemeteryInspectionEvent < Event
  class Type
    CEMETERY_INSPECTION_COMPLETED = 'completed'
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