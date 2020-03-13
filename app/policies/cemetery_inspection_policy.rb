class CemeteryInspectionPolicy < ApplicationPolicy
  def additional_information?
    finalize?
  end

  def cemetery_information?
    finalize?
  end

  def create_old_inspection?
    user.staff?
  end

  def finalize?
    record.belongs_to? user
  end

  def incomplete?
    user.investigator?
  end

  def perform?
    user.investigator?
  end

  def physical_characteristics?
    finalize?
  end

  def record_keeping?
    finalize?
  end

  def revise?
    finalize?
  end

  def show?
    user.staff?
  end

  def upload_old_inspection?
    create_old_inspection?
  end

  def view_full_package?
    show?
  end

  def view_report?
    show?
  end
end
