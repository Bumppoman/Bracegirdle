class User < ApplicationRecord
  has_many :appointments

  has_many :cemeteries,
    -> (user) {
      if user.investigator?
        unscope(:where).where(
          investigator_region: user.region)
      end
    }

  has_many :complaints,
    -> (user) {
      if user.supervisor?
        unscope(:where)
        .where(investigator: user, status: [:investigation_begun, :investigation_completed])
        .or(where(status: [:received, :pending_closure]))
      else
        where.not(status: [:pending_closure, :closed])
      end
    },
    foreign_key: :investigator_id,
    inverse_of: :investigator
    
  has_many :due_reminders,
    -> { due },
    class_name: 'Reminder'

  has_many :hazardous,
    -> (user) {
      if user.supervisor?
        unscope(:where)
        .where(investigator: user, status: :assigned)
        .or(where(status: :received))
      else
        where(status: :assigned)
      end
    },
    class_name: 'Hazardous',
    foreign_key: :investigator_id,
    inverse_of: :investigator

  has_many :incomplete_inspections,
    -> (user) {
      where.not(status: :completed)
    },
    class_name: 'CemeteryInspection',
    foreign_key: :investigator_id,
    inverse_of: :investigator

  has_many :land_purchases,
    -> (user) {
      where(application_type: :purchase, status: :received)
    },
    class_name: 'Land',
    foreign_key: :investigator_id,
    inverse_of: :investigator

  has_many :land_sales,
    -> (user) {
      where(application_type: :sale, status: :received)
    },
    class_name: 'Land',
    foreign_key: :investigator_id,
    inverse_of: :investigator

  has_many :overdue_inspections,
    -> (user) {
      unscope(:where)
      .where(investigator_region: user.region, active: true)
      .where('last_inspection_date < ? OR last_inspection_date IS NULL', Date.current - 5.years)
      .order(:last_inspection_date)
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
    
  has_many :reminders,
    -> (user) {
      where(completed: false)
      .order(:due_date)
    }

  has_many :rules_approvals,
    -> (user) {
      if user.supervisor?
        unscope(:where)
        .where(investigator: user, status: [:pending_review, :revision_requested])
        .or(where(status: [:received, :approval_recommended]))
      else
        where.not(status: [:approval_recommended, :approved]).order(:submission_date)
      end
    },
    foreign_key: :investigator_id,
    inverse_of: :investigator

  scope :team, -> (team) {
    where(team: team, active: true).or(where(id: team))
  }

  enum role: [
    :unauthenticated,
    :cemeterian,
    :investigator,
    :accountant,
    :support
  ]

  STAFF_ROLES = %i(investigator accountant support).freeze

  def board_applications_count
    if investigator?
      @board_applications_count ||= land_sales.count + land_purchases.count + hazardous.count
    end
  end

  def first_name
    name.split(' ')[0]
  end

  def inbox_items_count
    if investigator?
      @inbox_items_count ||= rules_approvals.count
    end
  end

  def investigations_count
    if investigator?
      @investigations_count ||= complaints.count + notices.count
    end
  end

  def last_name
    name.split(' ')[1]
  end

  def region_name
    NAMED_REGIONS[region].capitalize
  end

  def signature
    filename = "#{name.to_s.downcase.split(' ').join}.tif"
    Pathname.new(Rails.root.join('app', 'pdfs', 'signatures', filename)).exist? ? filename : nil
  end

  def staff?
    STAFF_ROLES.include? role.to_sym
  end
end
