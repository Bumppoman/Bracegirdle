class Revision < ApplicationRecord
  include Statable
  
  belongs_to :rules_approval
  
  enum status: {
    requested: 1,
    withdrawn: 2,
    received: 3
  }
  
  has_one_attached :rules_document
  
  FINAL_STATUSES = [:withdrawn, :received]

  INITIAL_STATUSES = [:requested, :received]

  NAMED_STATUSES = {
    requested: 'Requested',
    withdrawn: 'Withdrawn',
    received: 'Received'
  }.freeze
  
  def formatted_date_received
    if requested?
      'Not yet received'
    elsif withdrawn?
      'Rules approval withdrawn'
    else
      status_changes.where(status: self.class.statuses[:received]).last.created_at.to_s
    end
  end
  
  def date_requested
    status_changes.where(status: self.class.statuses[:requested]).last&.created_at.to_s
  end
end
