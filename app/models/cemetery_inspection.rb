class CemeteryInspection < ApplicationRecord
  attribute :cemetery_county, :integer
  attribute :date_performed, :date

  belongs_to :cemetery
  belongs_to :investigator, class_name: 'User'

  has_one_attached :inspection_report

  NAMED_STATUSES = {
      1 => 'Performed',
      4 => 'Complete'
  }.freeze

  STATUSES = {
    performed: 1,
    complete: 4
  }.freeze

  def named_status
    NAMED_STATUSES[status]
  end

  def score
    return '---' if inspection_report.attached?
  end

  def to_param
    date_performed.strftime('%Y-%m-%d')
  end
end
