class ChangeTrusteesToArchival < ActiveRecord::Migration[6.0]
  def change
    add_column :trustees, :active, :boolean, default: true
    add_column :trustees, :removal_date, :datetime
    add_column :trustees, :sort_name, :string
  end
end
