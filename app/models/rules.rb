class Rules < ApplicationRecord
  include Notable

  attribute :cemetery_county, :string

  belongs_to :cemetery

  has_many_attached :rules_documents

  scope :active_for, -> (user) {
    joins(:cemetery).where('status < ?', 4).where(cemeteries: { county: REGIONS[user.region]})
  }

  validates :request_by_email, presence: true
  validates :sender, presence: true
  validate :address_or_email_must_be_present

  NAMED_STATUSES = {
      1 => 'Pending Review',
      2 => 'Waiting for Revisions',
      3 => 'Approved'
  }.freeze

  def named_status
    NAMED_STATUSES[status]
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
end
