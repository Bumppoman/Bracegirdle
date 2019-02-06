class User < ApplicationRecord
  has_many :cemeteries,
    -> (user) {
      unscope(:where).where(
        county: REGIONS[user.region])}
  has_many :complaints, foreign_key: :investigator_id, inverse_of: :investigator
  has_many :non_compliance_notices, foreign_key: :investigator_id, inverse_of: :investigator
  has_many :rules,
    -> (user) {
      unscope(:where).where(
        cemetery: user.cemeteries)},
    class_name: 'Rules'

  has_secure_password

  def first_name
    name.split(' ')[0]
  end

  def has_role?(test_role)
    role >= NAMED_ROLES[test_role]
  end

  def region_name
    NAMED_REGIONS[region].capitalize
  end

  def supervisor?
    has_role?(:supervisor)
  end
end
