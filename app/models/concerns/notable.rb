module Notable
  extend ActiveSupport::Concern

  included do
    has_many :notes, -> { order created_at: :desc }, as: :notable
  end
end