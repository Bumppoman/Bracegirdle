class Land < BoardApplication
  include Statable

  after_commit :set_identifier, on: :create

  attribute :cemetery_county, :string
  attribute :trustee_position, :integer

  belongs_to :cemetery, foreign_key: :cemetery_cemid
  belongs_to :investigator, class_name: 'User', foreign_key: :investigator_id, optional: true
  belongs_to :trustee

  has_one_attached :raw_application_file

  scope :active_for, -> (user) {
    where(investigator: user)
    .where.not(status: FINAL_STATUSES)
  }

  scope :active_purchases_for, -> (user) {
    where(application_type: :purchase, investigator: user)
    .where.not(status: FINAL_STATUSES)
  }

  scope :active_sales_for, -> (user) {
    where(application_type: :sale, investigator: user)
        .where.not(status: FINAL_STATUSES)
  }

  scope :pending_supervisor_review, -> { where(status: :evaluated) }

  enum application_type: [:purchase, :sale]

  enum status: {
    received: 1,
    assigned: 2,
    incomplete: 3,
    evaluated: 4,
    reviewed: 5,
    scheduled: 6,
    withdrawn: 7,
    denied: 8,
    approved: 9,
    
  }

  FINAL_STATUSES = [:withdrawn, :denied, :approved]

  INITIAL_STATUSES = [:received, :assigned]

  NAMED_STATUSES = {
    received: 'Received',
    assigned: 'Awaiting evaluation',
    incomplete: 'Incomplete',
    evaluated: 'Sent to supervisor',
    reviewed: 'Ready for Cemetery Board',
    scheduled: 'Scheduled for Cemetery Board review',
    approved: 'Approved by Cemetery Board',
    withdrawn: 'Withdrawn',
    denied: 'Denied by Cemetery Board',
    completed: 'Completed'
  }.freeze

  def formatted_application_type
    "Land #{application_type}"
  end

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
