# frozen_string_literal: true

class Cemetery < ApplicationRecord
  self.primary_key = :cemid
    
  attribute :location, :string

  has_many :approved_rules,
    -> { order(approval_date: :desc) },
    class_name: 'Rules',
    foreign_key: :cemetery_cemid
  has_many :cemetery_inspections, foreign_key: :cemetery_cemid
  has_many :cemetery_locations, foreign_key: :cemetery_cemid
  has_many :complaints, foreign_key: :cemetery_cemid
  has_one :current_rules, 
    -> {
      order(approval_date: :desc)
    },
    class_name: 'Rules',
    foreign_key: :cemetery_cemid
  has_one :last_inspection,
    -> (cemetery) {
      where(date_performed: cemetery.last_inspection_date)
    },
    class_name: 'CemeteryInspection',
    foreign_key: :cemetery_cemid
  has_many :notices, foreign_key: :cemetery_cemid
  has_and_belongs_to_many :towns, foreign_key: :cemetery_cemid
  has_many :trustees, -> {
    order(:position, :sort_name)
  }, foreign_key: :cemetery_cemid

  scope :active, -> {
    where(active: true)
  }

  def abandoned?
    self[:active] == false
  end

  def county_name
    COUNTIES[county]
  end
  
  def formatted_cemid
    "##{cemid[0..1]}-#{cemid[2..]}"
  end
  
  def formatted_name
    "#{name} (#{formatted_cemid})"
  end

  def investigator
    User.find_by_region(region :investigator)
  end

  def latitude
    cemetery_locations.first.latitude
  end

  def longitude
    cemetery_locations.first.longitude
  end

  def region(type)
    if type == :investigator
      INVESTIGATOR_COUNTIES_BY_REGION[county]
    end
  end
  
  def to_param
    cemid
  end

  def to_s
    name
  end
end
