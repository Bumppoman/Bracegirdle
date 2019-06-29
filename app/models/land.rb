class Land < ApplicationRecord
  include Statable

  after_commit :set_identifier, on: :create

  attribute :cemetery_county, :string
  attribute :trustee_position, :integer

  belongs_to :cemetery
  belongs_to :investigator, class_name: 'User', foreign_key: :investigator_id, optional: true

  has_one_attached :raw_application_file

  scope :active_for, -> (user) {
    where(investigator: user)
    .where.not(status: :approved)
  }

  scope :active_purchases_for, -> (user) {
    where(application_type: :purchase, investigator: user)
    .where.not(status: :approved)
  }

  scope :active_sales_for, -> (user) {
    where(application_type: :sale, investigator: user)
        .where.not(status: :approved)
  }

  scope :pending_supervisor_review, -> { where(status: :processed) }

  enum application_type: [:purchase, :sale]

  enum status: {
    received: 1,
    processed: 2,
    reviewed: 3,
    approved: 4
  }

  FINAL_STATUSES = [:approved]

  INITIAL_STATUSES = [:received]

  NAMED_STATUSES = {
      received: 'Received',
      processed: 'Sent to supervisor',
      reviewed: 'Sent to Cemetery Board',
      approved: 'Approved by Cemetery Board'
  }.freeze

  def to_s
    identifier
  end

  def to_sym
    :land
  end

  private

  def set_identifier
    update(identifier: "LAND-#{Date.current.year}-#{'%05d' % id}")
  end
end
