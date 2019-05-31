# frozen_string_literal: true

class Notice < ApplicationRecord
  include Attachable
  include Notable
  include Statable

  after_commit :set_notice_number, on: :create

  attribute :cemetery_county, :string

  belongs_to :cemetery
  belongs_to :investigator, class_name: 'User',
                            foreign_key: :investigator_id,
                            inverse_of: :notices

  enum status: {
      issued: 1,
      response_received: 2,
      follow_up_completed: 3,
      resolved: 4
  }

  scope :active, -> { where.not(status: :resolved)}
  scope :active_for, -> (user) { active.where(investigator: user) }

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

  FINAL_STATUSES = [:resolved]

  INITIAL_STATUSES = [:issued]

  NAMED_STATUSES = {
      issued: 'Notice Issued',
      response_received: 'Response Received',
      follow_up_completed: 'Follow-Up Completed',
      resolved: 'Notice Resolved'
  }.freeze

  def active?
    !resolved?
  end

  def belongs_to?(user)
    investigator == user
  end

  def formatted_status
    NAMED_STATUSES[status.to_sym]
  end

  def response_required_status
    date = Time.zone.today
    if date < response_required_date
      "#{(response_required_date - date).to_i} days remaining"
    elsif date == response_required_date
      'due today'
    else
      "#{(date - response_required_date).to_i} days overdue"
    end
  end

  private

  def set_notice_number
    self.notice_number = "#{investigator.office_code}-#{Date.current.year}-#{'%04i' % id}"
    save
  end
end
