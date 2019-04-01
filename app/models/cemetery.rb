# frozen_string_literal: true

class Cemetery < ApplicationRecord
  include Locatable

  has_many :complaints
  has_many :cemetery_inspections
  has_one :last_inspection,
    -> (cemetery) {
      where(date_performed: cemetery.last_inspection_date)
    },
    class_name: 'CemeteryInspection'
  has_many :notices
  has_one :rules, -> {
      where(
        status: Rules::STATUSES[:approved]).
        order(approval_date: :desc)}
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

  def formatted_last_inspection
    if last_inspection
      "#{@cemetery.last_inspection_date} (#{link_to 'view', show_inspection_cemetery_path(date: @cemetery.last_inspection)})"
    elsif last_inspection_date
      last_inspection_date
    else
      'No inspection recorded'
    end
  end

  def investigator
    User.find_by_region(region :investigator)
  end

  def last_audit
    self[:last_audit] || 'No audit recorded'
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
