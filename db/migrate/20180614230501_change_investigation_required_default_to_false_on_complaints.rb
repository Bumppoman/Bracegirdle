class ChangeInvestigationRequiredDefaultToFalseOnComplaints < ActiveRecord::Migration[5.2]
  def change
    change_column_default :complaints, :investigation_required, false
  end
end
