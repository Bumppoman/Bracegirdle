class MergePeopleIntoTrustees < ActiveRecord::Migration[5.2]
  def change
    remove_column :trustees, :person_id
    add_column :trustees, "name", :string, before: :position
    add_column :trustees, "address", :string, before: :position
    add_column :trustees, "phone_number", :string, before: :position
    add_column :trustees, "email", :string, before: :position
    add_column :trustees, "latitude", :float, before: :position
    add_column :trustees, "longitude", :float, before: :position
  end
end
