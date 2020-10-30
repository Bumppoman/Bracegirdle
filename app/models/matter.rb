class Matter < ApplicationRecord
  include Statable

  belongs_to :board_application, polymorphic: true
  belongs_to :board_meeting, optional: true

  delegate :cemetery, to: :board_application

  enum status: {
    unscheduled: 1,
    scheduled: 2,
    legal_review: 3,
    denied: 4,
    returned_to_investigator: 5,
    tabled: 6,
    approved: 7
  }

  FINAL_STATUSES = [:denied, :approved]

  INITIAL_STATUSES = [:unscheduled]

  def to_s
    board_application.to_s
  end
end
