class Restoration < ApplicationRecord
  attribute :cemetery_county, :string
  attribute :trustee_position, :integer

  belongs_to :cemetery
  belongs_to :investigator, class_name: 'User', optional: true
  belongs_to :trustee

  has_many :estimates

  has_one_attached :application
  has_one_attached :legal_notice
  has_one_attached :raw_application_file

  scope :abandonment, -> { where(application_type: TYPES[:abandonment]) }
  scope :hazardous, -> { where(application_type: TYPES[:hazardous]) }
  scope :pending_review_for, -> (user) {
    all
  }
  scope :vandalism, -> { where(application_type: TYPES[:vandalism]) }

  with_options if: :newly_created? do |application|
    application.validates :amount, presence: true
    application.validates :submission_date, presence: true
  end

  TYPES = {
      vandalism: 1,
      hazardous: 2,
      abandonment: 3
  }.freeze

  def application_type=(type)
    self.write_attribute(:application_type, TYPES[type])
  end

  def newly_created?
    id.nil?
  end
end
