class Rules < ApplicationRecord
  include Notable

  after_commit :set_identifier, on: :create

  alias_attribute  :user, :investigator

  attribute :cemetery_county, :string

  belongs_to :cemetery
  belongs_to :investigator, class_name: 'User', optional: true

  has_many_attached :rules_documents

  scope :active, -> { where(status: [STATUSES[:pending_review], STATUSES[:revision_requested]]) }
  scope :active_for, -> (user) {
    if user.supervisor?
      where(investigator: user, status: [2, 3]).or(where(status: 1))
    else
      active.where(investigator: user)
    end
  }
  scope :approved, -> { where(status: STATUSES[:approved]) }
  scope :pending_review_for, -> (user) {
    where(status: STATUSES[:pending_review], investigator: user)
  }
  scope :unassigned, -> { where(status: STATUSES[:received]) }

  validates :request_by_email, inclusion: { in: [true, false] }, unless: :approved?
  validates :sender, presence: true, unless: :approved?
  validates :approval_date, presence: true, if: :approved?
  validate :address_or_email_must_be_present, unless: :approved?

  NAMED_STATUSES = {
    1 => 'Received',
    2 => 'Pending Review',
    3 => 'Waiting for Revisions',
    4 => 'Approved'
  }.freeze

  STATUSES = {
    received: 1,
    pending_review: 2,
    revision_requested: 3,
    approved: 4,
  }.freeze

  def active?
    !approved?
  end

  def approved?
    status == STATUSES[:approved]
  end

  def assigned_to?(user)
    user == investigator
  end

  def concern_text
    [nil, 'rules', "for #{cemetery.name}"]
  end

  def named_status
    NAMED_STATUSES[status]
  end

  def previously_approved?
    !sender.present?
  end

  def revision_received?
    return true if revision_request_date.nil?
    return rules_documents.last.created_at.to_date > revision_request_date
  end

  def status=(update)
    update = STATUSES[update] if update.is_a?(Symbol)
    self.write_attribute(:status, update)
  end

  def unassigned?
    status == STATUSES[:received]
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
    self.identifier = "#{created_at.year}-#{'%04d' % id}"
    save
  end
end
