class Rules < ApplicationRecord
  attribute :cemetery_county, :string
  attribute :email, :boolean

  belongs_to :cemetery

  has_many_attached :rule_documents
end
