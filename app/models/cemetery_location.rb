class CemeteryLocation < ApplicationRecord
  belongs_to :cemetery, foreign_key: :cemetery_cemid
end
