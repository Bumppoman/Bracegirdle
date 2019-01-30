module Notable
  extend ActiveSupport::Concern

  included do
    has_many :notes, -> { order :created_at }, as: :notable
  end
end