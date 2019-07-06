class Note < ApplicationRecord

  alias_attribute :concernable, :notable

  belongs_to :notable, polymorphic: true, touch: true
  belongs_to :user
end
