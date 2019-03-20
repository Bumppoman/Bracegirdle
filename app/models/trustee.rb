class Trustee < ApplicationRecord
  geocoded_by :full_address
  after_validation :geocode

  belongs_to :cemetery

  def formatted_email
    email || 'None'
  end

  def full_address
    "#{street_address}, #{city}, #{state} #{zip}"
  end

  def position_name
    POSITIONS[position]
  end
end
