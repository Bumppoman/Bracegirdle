module Statable
  extend ActiveSupport::Concern

  included do
    has_many :status_changes, -> { order created_at: :desc }, as: :statable
  end

  def formatted_status
    self.class::NAMED_STATUSES[status.to_sym]
  end
end