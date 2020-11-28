class CreateRetortModels < ActiveRecord::Migration[6.0]
  def change
    create_table :retort_models do |t|
      t.integer :manufacturer
      t.string :name
      t.integer :maximum_throughput
    end
  end
end
