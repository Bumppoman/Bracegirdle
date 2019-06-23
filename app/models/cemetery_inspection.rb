class CemeteryInspection < ApplicationRecord
  include Attachable

  after_commit :set_identifier, on: :create

  attribute :cemetery_county, :integer

  belongs_to :cemetery
  belongs_to :investigator, class_name: 'User', optional: true

  has_one_attached :inspection_report

  validates :date_performed, presence: true

  NAMED_STATUSES = {
      begun: 'In progress',
      performed: 'Performed',
      complete: 'Complete'
  }.freeze

  enum status: {
      begun: 2,
      performed: 3,
      complete: 4
  }

  def active?
    begun? || performed?
  end

  def current_inspection_step
    return 3 unless pet_burials.nil?
    return 2 unless renovations.nil?
    return 1 unless cemetery_sign_text.nil?
    0
  end

  def named_status
    NAMED_STATUSES[status.to_sym]
  end

  def score
    return '---' unless complete? && !inspection_report.attached?
  end

  def to_param
    identifier
  end

  def violations?
    violations = YAML.load_file(Rails.root.join('config', 'cemetery_inspections.yml'))['cemetery_inspections'].keys
    violations.each do |violation|
      return true if send(violation) == false
    end

    return false
  end

  private

  def set_identifier
    self.identifier = "#{date_performed.year}-INSP-#{'%05d' % id}"
    save
  end
end
