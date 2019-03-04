class Restoration < ApplicationRecord
  after_commit :set_identifier, on: :create

  attribute :cemetery_county, :string

  belongs_to :cemetery
  belongs_to :investigator, class_name: 'User', foreign_key: :user_id, optional: true
  belongs_to :trustee

  has_many :estimates, -> { order(:amount) }

  has_one_attached :application_form
  has_one_attached :legal_notice
  has_one_attached :previous_report
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

  NAMED_STATUSES = {
    1 => 'Received',
    2 => 'Sent to supervisor',
    3 => 'Sent to Cemetery Board',
    4 => 'Approved by Cemetery Board',
    5 => 'Awaiting repairs',
    6 => 'Repairs completed',
    7 => 'Follow up inspection completed',
    8 => 'Closed'
  }.freeze

  STATUSES = {
    received: 1,
    processed: 2,
    reviewed: 3,
    approved: 4,
    paid: 5,
    repaired: 6,
    verified: 7,
    closed: 8
  }.freeze

  TYPES = {
      vandalism: 1,
      hazardous: 2,
      abandonment: 3
  }.freeze

  TYPE_CODES = {
      vandalism: 'VAND',
      hazardous: 'HAZD',
      abandonment: 'ABND'
  }.freeze

  def application_type
    TYPES.key(self.read_attribute(:application_type))
  end

  def application_type=(type)
    self.write_attribute(:application_type, TYPES[type.to_sym])
  end

  def amount=(amount)
    self.write_attribute(:amount, amount.delete(',').to_f)
  end

  def current_processing_step
    return 0 if status >= STATUSES[:processed]
    return 3 if legal_notice.attached?
    return 2 if estimates.length > 0
    return 1 if application_form.attached?
    0
  end

  def formatted_application_type
    case application_type
    when :vandalism
      'Vandalism'
    when :hazardous
      'Hazardous Monuments'
    when :abandonment
      'Abandonment'
    end
  end

  def named_status
    NAMED_STATUSES[status]
  end

  def newly_created?
    id.nil?
  end

  def processed?
    status == STATUSES[:processed]
  end

  def to_s
    identifier
  end

  def total
    estimates.order(:amount).first.amount + legal_notice_cost
  end

  private

  def set_identifier
    self.identifier = "#{TYPE_CODES[application_type]}-#{created_at.year}-#{'%04d' % id}"
    save
  end
end
