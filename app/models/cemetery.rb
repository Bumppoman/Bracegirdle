class Cemetery < ApplicationRecord

  belongs_to :town
  has_many :trustees

  def abandoned?
    self[:active] == false
  end

  def active?
    self[:active] != false
  end

  def cemetery_id
    "%02d-%03d" % [self.county, self.order_id]
  end

  def county_name
    COUNTIES[self.county]
  end

  def last_audit
    self[:last_audit] || "No audit recorded"
  end

  def last_inspection
    self[:last_inspection] || "No inspection recorded"
  end
end
