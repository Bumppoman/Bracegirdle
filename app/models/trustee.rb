class Trustee < ApplicationRecord
  belongs_to :cemetery
  belongs_to :person

  def position_name
    POSITIONS[self[:position]]
  end
end
