class Rules < ApplicationRecord
  include Notable

  after_commit :set_identifier, on: :create

  attribute :cemetery_county, :string

  belongs_to :cemetery
  belongs_to :approved_by, class_name: 'User', optional: true

  has_many_attached :rules_documents

  scope :active, -> { where('status < ?', STATUSES[:approved]) }
  scope :active_for, -> (user) {
    active.joins(:cemetery).where(cemeteries: { county: REGIONS[user.region] })
  }
  scope :active_for_region, -> (region) {
    active.joins(:cemetery).where(cemeteries: { county: REGIONS[region] })
  }
  scope :approved, -> { where(status: 3) }
  scope :pending_review_for, -> (user) {
    joins(:cemetery).where(status: 1, cemeteries: { county: REGIONS[user.region] })
  }

  validates :request_by_email, inclusion: { in: [true, false] }, unless: :approved?
  validates :sender, presence: true, unless: :approved?
  validates :approval_date, presence: true, if: :approved?
  validate :address_or_email_must_be_present, unless: :approved?

  NAMED_STATUSES = {
    1 => 'Pending Review',
    2 => 'Waiting for Revisions',
    3 => 'Approved'
  }.freeze

  STATUSES = {
    received: 1,
    revision_requested: 2,
    approved: 3,
  }.freeze

  def approved?
    status == STATUSES[:approved]
  end

  def named_status
    NAMED_STATUSES[status]
  end

  def status=(update)
    update = STATUSES[update] if update.is_a?(Symbol)
    self.write_attribute(:status, update)
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
