class Reminder < ApplicationRecord
  attribute :due_time, :string
  
  belongs_to :user
  
  scope :due, -> { 
    where(completed: :false)
    .where('due_date <= ?', Time.now) 
  }
end
