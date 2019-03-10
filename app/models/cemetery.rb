# frozen_string_literal: true

class Cemetery < ApplicationRecord
  include Locatable

  has_many :complaints
  has_many :notices
  has_one :rules,
    -> (cemetery) {
      where(
        cemetery: cemetery,
        status: Rules::STATUSES[:approved]).order(
        approval_date: :desc)}
  has_and_belongs_to_many :towns
  has_many :trustees, dependent: :destroy

  scope :active, -> {
    where(active: true).order(:order_id)
  }

  def abandoned?
    self[:active] == false
  end

  def active?
    self[:active] != false
  end

  def cemetery_id
    '%02d-%03d' % [county, order_id]
  end

  def county_name
    COUNTIES[county]
  end

  def investigator
    User.find_by_region(region :investigator)
  end

  def last_audit
    self[:last_audit] || 'No audit recorded'
  end

  def last_inspection
    self[:last_inspection] || 'No inspection recorded'
  end

  def latitude
    locations.first.latitude
  end

  def longitude
    locations.first.longitude
  end

  def to_s
    name
  end

  private

  def region(type)
    if type == :investigator
      INVESTIGATOR_COUNTIES_BY_REGION[county]
    end
  end
end
