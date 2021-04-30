class BoardMeeting < ApplicationRecord
  attribute :raw_date, :date
  attribute :raw_time, :string
  
  has_many :applications,
    -> { where.not board_application_type: 'Restoration' },
    class_name: 'Matter'
  has_many :matters
  has_many :restorations,
    -> { where board_application_type: 'Restoration' },
    class_name: 'Matter'

  enum status: {
    scheduled: 1,
    agenda_finalized: 2,
    minutes_finalized: 3,
    minutes_approved: 4
  }
  
  validates :date, presence: true
  validates :location, presence: true

  def abandonment_count
    restorations_by_type('Abandonment').count
  end

  def hazardous_count
    restorations_by_type('Hazardous').count
  end

  def date_code
    @date_code ||= date.strftime('%Y–%m')
  end

  def set_matter_identifiers
    letters = ('E'..'Z').to_a
    index = initial_index + 3
    applications.each do |matter|
      matter.update(identifier: "#{date_code}–#{letters.shift}–#{'%02d' % (index += 1)}")
    end
  end

  def to_s
    date.strftime('%B %Y')
  end

  def vandalism_count
    restorations_by_type('Vandalism').count
  end

  private

  def restorations_by_type(type)
    restorations.joins('INNER JOIN restorations ON matters.board_application_id = restorations.id')
      .where(restorations: { type: type })
  end
end
