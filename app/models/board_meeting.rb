class BoardMeeting < ApplicationRecord
  has_many :matters,
    -> { where.not application_type: 'Restoration' }
  has_many :restoration,
    -> { where application_type: 'Restoration' },
    class_name: 'Matter'

  enum status: {
    scheduled: 1,
    agenda_finalized: 2,
    minutes_finalized: 3,
    minutes_approved: 4
  }

  def abandonment_count
    restoration_by_type('Abandonment').count
  end

  def hazardous_count
    restoration_by_type('Hazardous').count
  end

  def date_code
    @date_code ||= date.strftime('%Y–%m')
  end

  def set_matter_identifiers
    letters = ('E'..'Z').to_a
    index = initial_index + 3
    matters.each do |matter|
      matter.update(identifier: "#{date_code}–#{letters.shift}–#{'%02d' % (index += 1)}")
    end
  end

  def to_s
    date.strftime('%B %Y')
  end

  def vandalism_count
    restoration_by_type('Vandalism').count
  end

  private

  def restoration_by_type(type)
    restoration.joins('INNER JOIN restoration ON matters.application_id = restoration.id')
      .where(restoration: { type: type })
  end
end
