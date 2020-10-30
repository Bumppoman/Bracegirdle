# frozen_string_literal: true

class Contractor < ApplicationRecord
  include Locatable
  
  scope :active, -> {
    where(active: true)
  }
  
  def county_name
    COUNTIES[county]
  end
end
