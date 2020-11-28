class Note < ApplicationRecord
  self.strict_loading_by_default = false

  alias_attribute :concernable, :notable

  belongs_to :notable, polymorphic: true, touch: true
  belongs_to :user
end
