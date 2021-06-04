class CemeteryInspection < ApplicationRecord
  include Attachable, Statable

  after_commit :set_identifier, on: :create

  attribute :cemetery_county, :integer

  belongs_to :cemetery, foreign_key: :cemetery_cemid
  belongs_to :investigator, class_name: 'User', optional: true
  belongs_to :trustee, optional: true

  has_one_attached :inspection_report

  validates :date_performed, presence: true

  ADDITIONAL_DOCUMENTS = {
    rules: 'Rules and Regulations',
    by_laws: 'By-Laws',
    conflict: 'Conflict of Interest Policy',
    deed: 'Deed'
  }.freeze
  
  FINAL_STATUSES = [:completed]
  
  INITIAL_STATUSES = [:begun, :completed]

  NAMED_STATUSES = {
    begun: 'In progress',
    cemetery_information_gathered: 'In progress',
    physical_characteristics_surveyed: 'In progress',
    record_keeping_reviewed: 'In progress',
    additional_information_entered: 'In progress',
    performed: 'Performed',
    completed: 'Completed'
  }.freeze

  enum status: {
      begun: 1,
      cemetery_information_gathered: 2,
      physical_characteristics_surveyed: 3,
      record_keeping_reviewed: 4,
      performed: 5,
      completed: 6
  }

  def active?
    !completed?
  end

  def belongs_to?(user)
    user == investigator
  end

  def current_inspection_step
    self.class.statuses[status]
  end
  
  def formatted_directional_signs
    output = ''
    if directional_signs_required
      if directional_signs_present
        output << 'Required and posted'
      else
        output << 'Required but not posted'
      end
    else
      if directional_signs_present
        output << 'Not required but posted'
      else
        output << 'Not required'
      end
    end
    
    directional_signs_comments.blank? ? output : "#{output}; #{directional_signs_comments}"
  end
  
  def legacy?
    inspection_report.attached?
  end
  
  def link_text
    "Inspection #{self.identifier}"
  end

  def named_status
    NAMED_STATUSES[status.to_sym]
  end

  def score
    return '---' unless completed? && !legacy?
  end

  def to_param
    identifier
  end

  def violations?
    violations = YAML.load_file(Rails.root.join('config', 'cemetery_inspections.yml'))['cemetery_inspections']
    violations.each do |violation, attributes|
      if attributes['conditions']
        return true if attributes['conditions'].map { |condition, value|
          !send(condition).nil? && send(condition) == value
        }.all?
      else
        return true if send(violation) == false
      end
    end

    false
  end

  private

  def set_identifier
    self.identifier = "#{date_performed.year}-INSP-#{'%05d' % id}"
    save
  end
end
