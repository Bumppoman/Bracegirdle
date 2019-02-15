class Vandalism < ApplicationRecord
  #belongs_to :investigator, class_name: User

  has_many :estimates

  has_one_attached :application
  has_one_attached :legal_notice

  scope :pending_review_for, -> (user) {
    all
  }

end
