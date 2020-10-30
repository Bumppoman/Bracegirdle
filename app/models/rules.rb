class Rules < ApplicationRecord
  attribute :cemetery_county, :string

  belongs_to :approved_by, class_name: 'User', foreign_key: :approved_by_id, optional: true
  belongs_to :cemetery, foreign_key: :cemetery_cemid
  belongs_to :rules_approval, optional: true
  
  has_one_attached :rules_document
  
  def previously_approved?
    rules_approval.nil?
  end
end
