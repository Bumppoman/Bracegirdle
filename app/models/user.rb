class User < ApplicationRecord
  has_many :cemeteries,
    -> (user) {
      unscope(:where).where(
        county: REGIONS[user.region])}
  has_many :complaints, foreign_key: :investigator_id, inverse_of: :investigator
  has_many :notices, foreign_key: :investigator_id, inverse_of: :investigator
  has_many :rules,
    -> (user) {
      unscope(:where).where(
        cemetery: user.cemeteries).where(
        'status < ?', 3
      )},
    class_name: 'Rules'

  has_secure_password

  def first_name
    name.split(' ')[0]
  end

  def has_role?(test_role)
    role >= NAMED_ROLES[test_role]
  end

  def investigator?
    true
  end

  def region_name
    NAMED_REGIONS[region].capitalize
  end

  def signature
    filename = "#{name.to_s.downcase.split(' ').join}.tif"
    Pathname.new(Rails.root.join('app', 'pdfs', 'signatures', filename)).exist? ? filename : nil
  end

  def supervisor?
    has_role?(:supervisor)
  end
end
