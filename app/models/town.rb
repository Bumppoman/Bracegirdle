# frozen_string_literal: true

class Town < ApplicationRecord
  has_and_belongs_to_many :cemeteries, foreign_key: :cemeteries_cemid

  def to_s
    name
  end
end
