class AddAcceptedByToRules < ActiveRecord::Migration[5.2]
  def change
    add_reference :rules, :accepted_by, before: :approved_by
  end
end
