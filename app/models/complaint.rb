# frozen_string_literal: true

class Complaint < ApplicationRecord
  include Attachable
  include Notable
  include Statable

  after_commit :set_complaint_number, on: :create

  alias_attribute :user, :investigator

  belongs_to :cemetery, optional: true, foreign_key: :cemetery_cemid
  belongs_to :closed_by, class_name: 'User', foreign_key: :closed_by_id, optional: true
  belongs_to :investigator, class_name: 'User', foreign_key: :investigator_id, optional: true
  belongs_to :receiver, class_name: 'User', foreign_key: :receiver_id

  enum ownership_type: {
    purchase: 1,
    inheritance: 2,
    gift: 3,
    other: 4
  }

  enum status: {
    received: 1,
    investigation_begun: 2,
    investigation_completed: 3,
    pending_closure: 4,
    closed: 5
  }

  scope :active, -> { where.not(status: [:pending_closure, :closed]) }
  scope :active_for, -> (user) { active.where(investigator: user) }
  scope :team, -> (team) { joins(:investigator).where(users: { team: team }).or(joins(:investigator).where(investigator_id: team)) }
  scope :unassigned, -> { where(investigator: nil) }

  validates :complainant_name, presence: true
  validates :complaint_type, presence: true
  validates :summary, presence: true
  validates :form_of_relief, presence: true
  validates :date_of_event, presence: true
  validate :cemetery_is_completed, on: :create
  validate :disposition_not_empty_if_closed

  FINAL_STATUSES = [:closed]
  
  GROUPED_COMPLAINT_TYPES = [
    [
      'Investigatory', 
      [
        ['Board member issue', 1],
        ['Burial issues', 2],
        ['Burial rights', 3],
        ['Burial records', 4],
        ['Burial society issues', 5],
        ['Cemetery maintenance issues', 6],
        ['Cremation process', 7],
        ['Damaged monument', 8],
        ['Dangerous conditions', 9],
        ['Lot owner issues', 10],
        ['Monument issues', 11],
        ['Operating illegal cemetery', 12],
        ['Perpetual care issues', 13],
        ['Pet burial issues', 14],
        ['Rules and regulations issues', 15],
        ['Tree removal', 16],
        ['Winter burial', 17]
      ]
    ],
    [
      'Accounting', 
      [
        ['Embezzlement/Fraud', 18],
        ['Financial issues', 19],
        ['Financial records issues', 20],
        ['Service fee issues', 21],
        ['Sales contract issues', 22]
      ]
    ]
  ].freeze
  private_constant :GROUPED_COMPLAINT_TYPES

  INITIAL_STATUSES = [:received, :investigation_begun, :pending_closure, :closed]

  NAMED_MANNERS_OF_CONTACT = {
      1 => 'Phone',
      2 => 'Letter',
      3 => 'Email',
      4 => 'In Person'
  }.freeze
  private_constant :NAMED_MANNERS_OF_CONTACT

  NAMED_STATUSES = {
      received: 'Complaint received',
      investigation_begun: 'Investigation begun',
      investigation_completed: 'Investigation completed',
      pending_closure: 'Closure recommended',
      closed: 'Complaint closed'
  }.freeze
  
  RAW_COMPLAINT_TYPES = {
    1 => 'Board member issue',
    2 => 'Burial issues',
    3 => 'Burial rights',
    4 => 'Burial records',
    5 => 'Burial society issues',
    6 => 'Cemetery maintenance issues',
    7 => 'Cremation process',
    8 => 'Damaged monument',
    9 => 'Dangerous conditions',
    10 => 'Lot owner issues',
    11 => 'Monument issues',
    12 => 'Operating illegal cemetery',
    13 => 'Perpetual care issues',
    14 => 'Pet burial issues',
    15 => 'Rules and regulations issues',
    16 => 'Tree removal',
    17 => 'Winter burial',
    18 => 'Embezzlement/Fraud',
    19 => 'Financial issues',
    20 => 'Financial records issues',
    21 => 'Service fee issues',
    22 => 'Sales contract issues'
  }.freeze
  private_constant :RAW_COMPLAINT_TYPES
  
  class << self
    def grouped_complaint_types
      GROUPED_COMPLAINT_TYPES
    end
    
    def named_manners_of_contact
      NAMED_MANNERS_OF_CONTACT
    end
    
    def raw_complaint_types
      RAW_COMPLAINT_TYPES
    end
  end

  def active?
    !closed?
  end

  def belongs_to?(user)
    investigator == user
  end

  def cemetery_contact
    if person_contacted.blank?
      'No cemetery contact information provided'
    else
      string = person_contacted
      (string << ' (by ' << manner_of_contact.split(', ').map { |manner| NAMED_MANNERS_OF_CONTACT[manner.to_i].downcase }.join(', ') << ')') if manner_of_contact
      string
    end
  end

  def closure_date
    status_changes.where(status: self.class.statuses[:closed]).last&.created_at&.to_date
  end

  def complaint_type
    self[:complaint_type].split(', ') if self[:complaint_type].respond_to? :split
  end

  def concern_text
    ['complaint',  "##{complaint_number}", "against #{formatted_cemetery}"]
  end
  
  def current_step
    self.class.statuses[status]
  end

  def disposition_date
    if closed_by != investigator
      status_changes.where(status: self.class.statuses[:pending_closure]).last&.created_at&.to_date
    else
      status_changes.where(status: self.class.statuses[:closed]).last&.created_at&.to_date
    end
  end

  def formatted_cemetery
    if cemetery_alternate_name.present?
      cemetery_alternate_name
    else
      cemetery.name
    end
  end
  
  def formatted_cemetery_name
    if cemetery_alternate_name.present?
      cemetery_alternate_name
    else
      "#{cemetery.name} (#{cemetery.formatted_cemid})"
    end
  end

  def formatted_ownership_type
    ownership_type&.capitalize
  end

  def investigation_begun_date
    status_changes.where(status: self.class.statuses[:investigation_begun]).last&.created_at&.to_date
  end

  def investigation_completed_date
    status_changes.where(status: self.class.statuses[:investigation_completed]).last&.created_at&.to_date
  end

  def link_text
    "Complaint ##{complaint_number}"
  end

  def to_s
    complaint_number
  end

  def unassigned?
    investigator.nil?
  end

  private

  def cemetery_is_completed
    if cemetery_regulated?
      errors.add(:cemetery, :blank) unless cemetery
    else
      errors.add(:cemetery_alternate_name, :blank) unless cemetery_alternate_name
    end
  end

  def disposition_not_empty_if_closed
    if closed? || pending_closure?
      errors.add(:disposition, :blank) if disposition.blank?
    end
  end

  def set_complaint_number
    self.complaint_number = "CPLT-#{created_at.year}-#{'%05d' % id}"
    save
  end
end
