class CemeteryInspection < ApplicationRecord
  attribute :cemetery_county, :integer

  belongs_to :cemetery
  belongs_to :investigator, class_name: 'User', optional: true

  has_one_attached :inspection_report

  NAMED_STATUSES = {
      1 => 'Begun',
      2 => 'Performed',
      4 => 'Complete'
  }.freeze

  STATUSES = {
    begun: 1,
    performed: 2,
    complete: 4
  }.freeze

  def current_inspection_step
    return 1 unless cemetery_sign_text.nil?
    0
  end

  def named_status
    NAMED_STATUSES[status]
  end

  def score
    return '---' if inspection_report.attached?
  end

  def to_param
    uuid
  end
end
