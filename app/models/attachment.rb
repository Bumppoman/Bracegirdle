class Attachment < ApplicationRecord
  self.strict_loading_by_default = false

  belongs_to :attachable, polymorphic: true
  belongs_to :cemetery, foreign_key: :cemetery_cemid, optional: true
  belongs_to :user

  has_one_attached :file
end
