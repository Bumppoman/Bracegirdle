class Attachment < ApplicationRecord
  belongs_to :cemetery
  belongs_to :user

  has_one_attached :file

  def icon
    FILE_ICONS[file.filename.extension]
  end
end
