class Trustee < ApplicationRecord
  #geocoded_by :full_address
  #after_validation :geocode
  
  before_save :set_sort_name

  belongs_to :cemetery, foreign_key: :cemetery_cemid

  POSITIONS = {
      1 => 'President',
      2 => 'Vice President',
      3 => 'Secretary',
      4 => 'Treasurer',
      5 => 'Superintendent',
      6 => 'Trustee',
      7 => 'Operator',
      8 => 'Employee'
  }.freeze
  
  def as_option
    "#{name} (#{position_name})"
  end

  def formatted_email
    email || 'None'
  end

  def full_address
    city_state_zip = []
    city_state_zip << [city, state].join(', ') unless city.blank?
    city_state_zip << zip unless city.blank?
    
    [street_address.presence, city_state_zip.join(' ')].compact.join(', ')
  end

  def position_name
    POSITIONS[position]
  end
  
  private
  
  def set_sort_name
    sort_name = name.downcase.split(' ').reverse.join(' ')
  end
end
