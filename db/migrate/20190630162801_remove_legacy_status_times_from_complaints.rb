class RemoveLegacyStatusTimesFromComplaints < ActiveRecord::Migration[6.0]
  def change
    remove_column :complaints, :investigation_begin_date
    remove_column :complaints, :investigation_completion_date
    remove_column :complaints, :disposition_date
    remove_column :complaints, :closure_date
  end
end
