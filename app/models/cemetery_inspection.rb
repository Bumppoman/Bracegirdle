class CemeteryInspection < ApplicationRecord
  attribute :cemetery_county, :integer
  attribute :date_performed, :date

  belongs_to :cemetery
  belongs_to :investigator, class_name: 'User'

  has_one_attached :inspection_report

  STATUSES = {
    performed: 1,
    complete: 4
  }.freeze

  def to_param
    date_performed.strftime('%Y-%m-%d')
  end
end
