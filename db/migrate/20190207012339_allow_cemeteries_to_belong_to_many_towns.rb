class AllowCemeteriesToBelongToManyTowns < ActiveRecord::Migration[5.2]
  def change
    create_table :cemeteries_towns, id: false do |t|
      t.belongs_to :cemetery, index: true
      t.belongs_to :town, index: true
    end
  end
end
