class Retort < ApplicationRecord
  belongs_to :crematory, foreign_key: :crematory_cemid
  belongs_to :retort_model
  
  def formatted_status
    'In service'
  end
end
