class AddCemeteryAlternateNametoComplaints < ActiveRecord::Migration[5.2]
  def change
    add_column :complaints, :cemetery_alternate_name, :string, after: :ownership_type
    change_column_default :complaints, :court_action_pending, false
    change_column_default :complaints, :attorney_contacted, false
    change_column_default :complaints, :investigation_required, true
  end
end
