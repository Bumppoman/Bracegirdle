class User < ApplicationRecord
  has_many :complaints, foreign_key: :investigator_id, inverse_of: :investigator
  has_many :non_compliance_notices, foreign_key: :investigator_id, inverse_of: :investigator
end
