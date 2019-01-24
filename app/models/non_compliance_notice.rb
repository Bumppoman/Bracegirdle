class NonComplianceNotice < ApplicationRecord
  belongs_to :cemetery
  belongs_to :investigator, class_name: :user, foreign_key: :investigator_id

  validates_presence_of :served_on_name
  validates_presence_of :served_on_title
  validates_presence_of :served_on_street_address
  validates_presence_of :served_on_city
  validates_presence_of :served_on_state
  validates_presence_of :served_on_zip
  validates_presence_of :law_sections
  validates_presence_of :specific_information
  validates_presence_of :violation_date
  validates_presence_of :response_required_date
end
