module Locatable
  extend ActiveSupport::Concern

  included do
    has_many :locations, as: :locatable
  end
end