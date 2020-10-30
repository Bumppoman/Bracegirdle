class Appointment < ApplicationRecord
  belongs_to :cemetery, foreign_key: :cemetery_cemid
  belongs_to :user

  enum status: {
    scheduled: 1,
    cancelled: 2,
    completed: 3
  }

  def belongs_to?(provided_user)
    provided_user == user
  end
end
