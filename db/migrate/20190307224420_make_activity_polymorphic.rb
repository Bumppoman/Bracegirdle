class MakeActivityPolymorphic < ActiveRecord::Migration[5.2]
  def change
    rename_column :activities, :model_type, :object_type
    rename_column :activities, :model_id, :object_id
  end
end
