class CemeteryInspection < ApplicationRecord
  after_commit :set_identifier, on: :create

  attribute :cemetery_county, :integer

  belongs_to :cemetery
  belongs_to :investigator, class_name: 'User', optional: true

  has_one_attached :inspection_report

  NAMED_STATUSES = {
      1 => 'In progress',
      2 => 'Performed',
      4 => 'Complete'
  }.freeze

  STATUSES = {
    begun: 1,
    performed: 2,
    complete: 4
  }.freeze

  def complete?
    status == STATUSES[:complete]
  end

  def current_inspection_step
    return 2 unless renovations.nil?
    return 1 unless cemetery_sign_text.nil?
    0
  end

  def named_status
    NAMED_STATUSES[status]
  end

  def performed?
    status == STATUSES[:performed]
  end

  def score
    return '---' unless complete?
  end

  def to_param
    identifier
  end

  private

  def set_identifier
    self.identifier = "#{date_performed.year}-INSP-#{'%05d' % id}"
    save
  end
end
