class Trustee < ApplicationRecord
  geocoded_by :full_address
  after_validation :geocode

  belongs_to :cemetery

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
