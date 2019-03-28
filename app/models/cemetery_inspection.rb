class CemeteryInspection < ApplicationRecord
  belongs_to :cemetery
  belongs_to :investigator, class_name: 'User'
  belongs_to :trustee
end
