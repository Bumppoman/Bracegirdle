class CemeteryInspection < ApplicationRecord
  after_commit :set_identifier, on: :create

  attribute :cemetery_county, :integer

  belongs_to :cemetery
  belongs_to :investigator, class_name: 'User', optional: true

  has_one_attached :inspection_report

  NAMED_STATUSES = {
      begun: 'In progress',
      performed: 'Performed',
      complete: 'Complete'
  }.freeze

  enum status: {
      begun: 1,
      performed: 2,
      complete: 4
  }

  def current_inspection_step
    return 2 if renovations.present?
    return 1 if cemetery_sign_text.present?
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
    true
  end

  private

  def set_identifier
    self.identifier = "#{date_performed.year}-INSP-#{'%05d' % id}"
    save
  end
end
