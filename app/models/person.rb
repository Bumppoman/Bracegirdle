# frozen_string_literal: true

class Person < ApplicationRecord
  geocoded_by :address
  after_validation :geocode

  def formatted_email
    email || 'None'
  end
end
