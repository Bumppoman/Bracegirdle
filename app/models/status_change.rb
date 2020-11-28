class StatusChange < ApplicationRecord
  self.strict_loading_by_default = false

  belongs_to :statable, polymorphic: true
end
