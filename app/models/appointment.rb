class Appointment < ApplicationRecord
  belongs_to :cemetery
  belongs_to :user

  enum status: {
    scheduled: 1,
    cancelled: 2,
    completed: 3
  }
end
