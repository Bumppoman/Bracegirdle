class Restoration < BoardApplication
  include Notable, Statable

  after_commit :set_identifier, on: :create

  alias_attribute :user, :investigator

  attribute :cemetery_county, :string

  belongs_to :cemetery, foreign_key: :cemetery_cemid
  belongs_to :investigator, class_name: 'User', foreign_key: :investigator_id, optional: true
  belongs_to :reviewer, class_name: 'User', foreign_key: :reviewer_id, optional: true
  belongs_to :trustee

  TYPES = {
      vandalism: 1,
      hazardous: 2,
      abandonment: 3
  }.freeze

  enum previous_type: TYPES, _prefix: true
  enum status: {
      received: 1,
      assigned: 2,
      incomplete: 3,
      evaluated: 4,
      reviewed: 5,
      scheduled: 6,
      approved: 7,
      paid: 8,
      repaired: 9,
      verified: 10,
      withdrawn: 11,
      denied: 12,
      completed: 13
  }

  has_many :estimates, -> { order(:amount) }

  has_one_attached :application_file
  has_one_attached :legal_notice_file
  has_one_attached :previous_completion_report_file
  has_one_attached :raw_application_file

  scope :pending_supervisor_review, -> { where(status: :evaluated) }
  scope :team, -> (team) { joins(:investigator).where(users: { team: team }).or(joins(:investigator).where(investigator_id: team)) }

  with_options if: :newly_created? do
    validates :amount, presence: true
    validates :submission_date, presence: true
  end

  FINAL_STATUSES = [:withdrawn, :denied, :completed]

  INITIAL_STATUSES = [:received, :assigned]

  NAMED_STATUSES = {
    received: 'Received',
    assigned: 'Awaiting evaluation',
    incomplete: 'Incomplete',
    evaluated: 'Sent to supervisor',
    reviewed: 'Ready for Cemetery Board',
    scheduled: 'Scheduled for Cemetery Board review',
    approved: 'Approved by Cemetery Board',
    paid: 'Awaiting repairs',
    repaired: 'Repairs completed',
    verified: 'Follow up inspection completed',
    withdrawn: 'Withdrawn',
    denied: 'Denied by Cemetery Board',
    completed: 'Completed'
  }.freeze

  TYPE_CODES = {
      vandalism: 'VAND',
      hazardous: 'HAZD',
      abandonment: 'ABND'
  }.freeze

  def active?
    !withdrawn? && !denied? && !completed?
  end

  def amount=(amount)
    self.write_attribute(:amount, amount.delete(',').to_f)
  end

  def calculated_amount
    estimates.first.amount + legal_notice_cost
  end
  
  def concern_text
    ['a', 'restoration application', "for #{cemetery.name}"]
  end

  def current_evaluation_step
    return 1 unless received? || assigned?
    return 5 unless previous_exists.nil?
    return 4 if legal_notice_file.attached?
    return 3 if estimates.length > 0
    return 2 if application_file.attached?
    1
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
