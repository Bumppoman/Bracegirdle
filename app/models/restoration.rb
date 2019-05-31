class Restoration < ApplicationRecord
  include Notable
  include Statable

  after_commit :set_identifier, on: :create

  alias_attribute :user, :investigator

  attribute :cemetery_county, :string
  attribute :trustee_position, :integer

  belongs_to :cemetery
  belongs_to :investigator, class_name: 'User', foreign_key: :investigator_id, optional: true
  belongs_to :reviewer, class_name: 'User', foreign_key: :reviewer_id, optional: true

  enum status: {
      received: 1,
      processed: 2,
      reviewed: 3,
      approved: 4,
      paid: 5,
      repaired: 6,
      verified: 7,
      closed: 8
  }

  enum application_type: {
      vandalism: 1,
      hazardous: 2,
      abandonment: 3
  }

  has_many :estimates, -> { order(:amount) }

  has_one_attached :application_form
  has_one_attached :legal_notice
  has_one_attached :previous_report
  has_one_attached :raw_application_file

  scope :pending_supervisor_review, -> { where(status: :processed) }

  with_options if: :newly_created? do |application|
    application.validates :amount, presence: true
    application.validates :submission_date, presence: true
  end

  FINAL_STATUSES = [:closed]

  INITIAL_STATUSES = [:received]

  NAMED_STATUSES = {
    received: 'Received',
    processed: 'Sent to supervisor',
    reviewed: 'Sent to Cemetery Board',
    approved: 'Approved by Cemetery Board',
    paid: 'Awaiting repairs',
    repaired: 'Repairs completed',
    verified: 'Follow up inspection completed',
    closed: 'Closed'
  }.freeze

  TYPE_CODES = {
      vandalism: 'VAND',
      hazardous: 'HAZD',
      abandonment: 'ABND'
  }.freeze

  def active?
    !closed?
  end

  def amount=(amount)
    self.write_attribute(:amount, amount.delete(',').to_f)
  end

  def calculated_amount
    estimates.first.amount + legal_notice_cost
  end

  def current_processing_step
    return 0 unless received?
    return 4 unless previous_exists.nil?
    return 3 if legal_notice.attached?
    return 2 if estimates.length > 0
    return 1 if application_form.attached?
    0
  end

  def formatted_application_type
    formatted_type(application_type)
  end

  def formatted_previous_type
    formatted_type(previous_type).downcase
  end

  def named_status
    NAMED_STATUSES[status.to_sym]
  end

  def newly_created?
    id.nil?
  end

  def previous_type
    self.class.application_types.key(self.read_attribute(:previous_type))
  end

  def to_s
    identifier
  end

  def total
    estimates.order(:amount).first.amount + legal_notice_cost
  end

  private

  def formatted_type(type)
    case type
    when :vandalism
      'Vandalism'
    when :hazardous
      'Hazardous Monuments'
    when :abandonment
      'Abandonment'
    end
  end

  def set_identifier
    self.identifier = "#{TYPE_CODES[application_type.to_sym]}-#{created_at.year}-#{'%04d' % id}"
    save
  end
end
