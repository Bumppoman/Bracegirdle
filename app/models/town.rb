# frozen_string_literal: true

class Town < ApplicationRecord
  has_and_belongs_to_many :cemeteries

  def to_s
    name
  end
end
