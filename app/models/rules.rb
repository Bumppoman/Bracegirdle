class Rules < ApplicationRecord
  include Notable

  after_commit :set_identifier, on: :create

  attribute :cemetery_county, :string

  belongs_to :cemetery
  belongs_to :accepted_by, class_name: 'User', optional: true
  belongs_to :approved_by, class_name: 'User', optional: true

  has_many_attached :rules_documents

  scope :active, -> { where('status < ?', STATUSES[:approved]) }
  scope :active_for, -> (user) {
    active.joins(:cemetery).where('(cemeteries.county IN (?) AND accepted_by_id IS NULL) OR accepted_by_id = ?', REGIONS[user.region], user.id)
  }
  scope :approved, -> { where(status: STATUSES[:approved]) }
  scope :pending_review_for, -> (user) {
    joins(:cemetery).where('(status = ? AND cemeteries.county IN (?)) OR (status = ? AND accepted_by_id = ?)', STATUSES[:received], REGIONS[user.region], STATUSES[:accepted], user.id)
  }
  scope :pending_review_for_region, -> (region) {
    joins(:cemetery).where(cemeteries: { county: REGIONS[region] }, status: 1)
  }

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
    accepted: 2,
    revision_requested: 3,
    approved: 4,
  }.freeze

  def accepted_by?(user)
    accepted_by == user
  end

  def approved?
    status == STATUSES[:approved]
  end

  def assigned_to?(user)
    return false if accepted_by && accepted_by != user
    REGIONS[user.region].include? cemetery.county
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

  def unaccepted?
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
