class Restoration < BoardApplication
  include Notable
  include Statable

  after_commit :set_identifier, on: :create

  alias_attribute :user, :investigator

  attribute :cemetery_county, :string
  attribute :trustee_position, :integer

  belongs_to :cemetery
  belongs_to :investigator, class_name: 'User', foreign_key: :investigator_id, optional: true
  belongs_to :reviewer, class_name: 'User', foreign_key: :reviewer_id, optional: true

  TYPES = {
      vandalism: 1,
      hazardous: 2,
      abandonment: 3
  }.freeze

  enum previous_type: TYPES, _prefix: true
  enum status: {
      received: 1,
      processed: 2,
      reviewed: 3,
      scheduled: 4,
      approved: 5,
      paid: 6,
      repaired: 7,
      verified: 8,
      closed: 9
  }

  has_many :estimates, -> { order(:amount) }

  has_one_attached :application_form
  has_one_attached :legal_notice
  has_one_attached :previous_report
  has_one_attached :raw_application_file

  scope :pending_supervisor_review, -> { where(status: :processed) }
  scope :team, -> (team) { joins(:investigator).where(users: { team: team }).or(joins(:investigator).where(investigator_id: team)) }

  with_options if: :newly_created? do
    validates :amount, presence: true
    validates :submission_date, presence: true
  end

  FINAL_STATUSES = [:closed]

  INITIAL_STATUSES = [:received]

  NAMED_STATUSES = {
    received: 'Received',
    processed: 'Sent to supervisor',
    reviewed: 'Sent to Cemetery Board',
    scheduled: 'Scheduled for Cemetery Board review',
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
    formatted_type(type.downcase.to_sym)
  end

  def formatted_previous_type
    formatted_type(previous_type.to_sym)
  end

  def named_status
    NAMED_STATUSES[status.to_sym]
  end

  def newly_created?
    id.nil?
  end

  def to_s
    identifier
  end

  private

  def formatted_type(type)
    case type
    when :vandalism
      'Vandalism'
    when :hazardous
      'Hazardous'
    when :abandonment
      'Abandonment'
    end
  end

  def set_identifier
    self.identifier = "#{TYPE_CODES[type.downcase.to_sym]}-#{created_at.year}-#{'%05d' % id}"
    save
  end
end
