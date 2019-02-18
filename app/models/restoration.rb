class Restoration < ApplicationRecord
  attribute :cemetery_county, :string

  belongs_to :cemetery

  has_many :estimates

  has_one_attached :application
  has_one_attached :legal_notice

  scope :abandonment, -> { where(application_type: TYPES[:abandonment]) }
  scope :hazardous, -> { where(application_type: TYPES[:hazardous]) }
  scope :pending_review_for, -> (user) {
    all
  }
  scope :vandalism, -> { where(application_type: TYPES[:vandalism]) }

  TYPES = {
      vandalism: 1,
      hazardous: 2,
      abandonment: 3
  }.freeze

end
