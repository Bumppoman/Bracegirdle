class StatusChange < ApplicationRecord
  belongs_to :statable, polymorphic: true
end
