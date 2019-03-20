class Trustee < ApplicationRecord
  geocoded_by :full_address
  after_validation :geocode

  belongs_to :cemetery

  def formatted_email
    email || 'None'
  end

  def full_address
    [street_address.presence, city.presence, [state.presence, zip.presence].join(' ')].compact.join(', ')
  end

  def position_name
    POSITIONS[position]
  end
end
