class Trustee < ApplicationRecord
  geocoded_by :address
  after_validation :geocode

  belongs_to :cemetery

  def formatted_email
    email || 'None'
  end

  def position_name
    POSITIONS[position]
  end
end
