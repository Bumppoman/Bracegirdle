module Statable
  extend ActiveSupport::Concern

  included do
    has_many :status_changes, -> { order created_at: :desc }, as: :statable
  end

  def current_status_is_final?
    self.class::FINAL_STATUSES.include? status.to_sym
  end

  def current_status_is_initial?
    self.class::INITIAL_STATUSES.include? status.to_sym
  end

  def formatted_status
    self.class::NAMED_STATUSES[status.to_sym]
  end
end