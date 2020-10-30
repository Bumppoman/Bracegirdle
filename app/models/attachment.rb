class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  belongs_to :cemetery, optional: true
  belongs_to :user

  has_one_attached :file
end
