# frozen_string_literal: true

class Cemetery < ApplicationRecord
  include Locatable

  has_many :cemetery_inspections
  has_many :complaints
  has_one :last_inspection,
    -> (cemetery) {
      where(date_performed: cemetery.last_inspection_date)
    },
    class_name: 'CemeteryInspection'
  has_many :notices
  has_one :rules, -> {
      where(
        status: :approved).
        order(approval_date: :desc)}
  has_and_belongs_to_many :towns
  has_many :trustees, dependent: :destroy

  scope :active, -> {
    where(active: true).order(:county, :order_id)
  }

  def self.find_by_cemetery_id(cemetery_id)
    _, county, order_id = */(\d{2})-(\d{3})/.match(cemetery_id)
    self.where(county: county, order_id: order_id).first
  end

  def abandoned?
    self[:active] == false
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

  def latitude
    locations.first.latitude
  end

  def longitude
    locations.first.longitude
  end

  def region(type)
    if type == :investigator
      INVESTIGATOR_COUNTIES_BY_REGION[county]
    end
  end

  def to_param
    cemetery_id
  end

  def to_s
    name
  end
end
