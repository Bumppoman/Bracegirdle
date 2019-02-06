# frozen_string_literal: true

class NonComplianceNotice < ApplicationRecord
  include Notable

  after_commit :set_notice_number, on: :create

  attribute :cemetery_county, :string

  belongs_to :cemetery
  belongs_to :investigator, class_name: 'User',
                            foreign_key: :investigator_id,
                            inverse_of: :non_compliance_notices

  scope :active, -> { where('status < ?', 4)}

  validates :served_on_name, presence: true
  validates :served_on_title, presence: true
  validates :served_on_street_address, presence: true
  validates :served_on_city, presence: true
  validates :served_on_state, presence: true
  validates :served_on_zip, presence: true
  validates :law_sections, presence: true
  validates :specific_information, presence: true
  validates :violation_date, presence: true
  validates :response_required_date, presence: true

  def formatted_status
    NON_COMPLIANCE_NOTICE_STATUSES[status]
  end

  def response_required_status
    date = Time.zone.today
    if date < response_required_date
      "#{(response_required_date - date).to_i} days remaining"
    elsif date == response_required_date
      "due today"
    else
      "#{(date - response_required_date).to_i} days overdue"
    end
  end

  private

  def set_notice_number
    self.notice_number = "#{investigator.office_code}-#{Time.zone.today.year}-#{'%04i' % id}"
    save
  end
end
