class User < ApplicationRecord
  has_many :cemeteries,
    -> (user) {
      unscope(:where).where(
        county: REGIONS[user.region])}

  has_many :complaints,
    -> (user) {
      where.not(status: [:pending_closure, :closed])
    },
    foreign_key: :investigator_id,
    inverse_of: :investigator

  has_many :hazardous,
    -> (user) {
      where(
        status: [
          :received
        ],
        application_type: :hazardous)
    },
    class_name: 'Restoration',
    foreign_key: :investigator_id,
    inverse_of: :investigator

  has_many :incomplete_inspections,
    -> (user) {
      where('status < ?', CemeteryInspection::STATUSES[:complete])
    },
    class_name: 'CemeteryInspection',
    foreign_key: :investigator_id,
    inverse_of: :investigator

  has_many :overdue_inspections,
    -> (user) {
      unscope(:where)
      .where(investigator_region: user.region, active: true)
      .where('last_inspection_date < ? OR last_inspection_date IS NULL', Date.current - 5.years)
      .order('last_inspection_date ASC')
    },
    class_name: 'Cemetery'

  has_many :notices,
    -> (user) {
      where.not(status: :resolved)
    },
    foreign_key: :investigator_id,
    inverse_of: :investigator

  has_many :notifications,
    -> (user) {
      where(read: false)
    },
    foreign_key: :receiver_id

  has_many :restoration,
    -> (user) {
      where(status: [
        :received
      ])
    },
    foreign_key: :investigator_id,
    inverse_of: :investigator

  has_many :rules,
    -> (user) {
      if user.supervisor?
        unscope(:where).where(investigator: user, status: [:pending_review, :revision_requested]).or(where(status: :received))
      else
        where.not(status: :approved).order(:submission_date)
      end
    },
    foreign_key: :investigator_id,
    inverse_of: :investigator


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
