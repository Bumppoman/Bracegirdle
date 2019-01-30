# frozen_string_literal: true

class NonComplianceNotice < ApplicationRecord
  include Notable

  after_commit :set_notice_number, on: :create

  attribute :cemetery_county, :string

  belongs_to :cemetery
  belongs_to :investigator, class_name: 'User',
                            foreign_key: :investigator_id,
                            inverse_of: :non_compliance_notices

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

  private

  def set_notice_number
    self.notice_number = "#{investigator.office_code}-#{Time.zone.today.year}-#{'%04i' % id}"
    save
  end
end
