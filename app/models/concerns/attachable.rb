module Attachable
  extend ActiveSupport::Concern

  included do
    has_many :attachments, -> { order created_at: :desc }, as: :attachable
  end
end