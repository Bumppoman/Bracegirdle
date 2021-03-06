class RulesApproval < ApplicationRecord
  include Notable, Statable

  after_commit :set_identifier, on: :create

  alias_attribute  :user, :investigator

  attribute :cemetery_county, :string

  belongs_to :approved_by, class_name: 'User', optional: true
  belongs_to :cemetery, foreign_key: :cemetery_cemid
  belongs_to :investigator, class_name: 'User', optional: true
  belongs_to :trustee

  enum status: {
      received: 1,
      pending_review: 2,
      revision_requested: 3,
      withdrawn: 4,
      approval_recommended: 5,
      approved: 6
  }

  has_one :approved_rules, class_name: 'Rules'
  has_many :revisions, -> { order(id: :desc) }

  scope :active, -> { where(status: [:received, :pending_review, :revision_requested]) }
  scope :active_for, -> (user) {
    if user.supervisor?
      where(investigator: user, status: [:pending_review, :revision_requested]).or(where(status: :received))
    else
      active.where(investigator: user)
    end
  }
  scope :pending_review_for, -> (user) {
    where(status: :pending_review, investigator: user)
  }

  validates :request_by_email, inclusion: { in: [true, false] }
  validate :address_or_email_must_be_present

  FINAL_STATUSES = [:withdrawn, :approved]

  INITIAL_STATUSES = [:received, :pending_review]

  NAMED_STATUSES = {
    received: 'Received',
    pending_review: 'Pending review',
    revision_requested: 'Waiting for revisions',
    withdrawn: 'Withdrawn',
    approval_recommended: 'Recommended for approval',
    approved: 'Approved'
  }.freeze

  def active?
    !approved?
  end

  def assigned_to?(user)
    user == investigator
  end

  def concern_text
    [nil, 'rules', "for #{cemetery.name}"]
  end

  def named_status
    NAMED_STATUSES[status.to_sym]
  end

  private

  def address_or_email_must_be_present
    if request_by_email?
      errors.add(:sender_email, :blank) unless sender_email.present?
    else
      errors.add(:sender_street_address, :blank) unless sender_street_address.present?
      errors.add(:sender_city, :blank) unless sender_city.present?
      errors.add(:sender_state, :blank) unless sender_state.present?
      errors.add(:sender_zip, :blank) unless sender_zip.present?
    end
  end

  def set_identifier
    self.identifier = "RULES-#{created_at.year}-#{'%05d' % id}"
    save
  end
end
