class AddIdentifierAndApprovedByToRules < ActiveRecord::Migration[5.2]
  def change
    add_column :rules, :identifier, :string
    add_reference :rules, :approved_by, after: :approval_date
    remove_column :rules, :file_name
  end
end
