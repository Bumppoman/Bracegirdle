class AddClosureDateToComplaint < ActiveRecord::Migration[5.2]
  def change
    add_column :complaints, :closure_date, :date
  end
end
