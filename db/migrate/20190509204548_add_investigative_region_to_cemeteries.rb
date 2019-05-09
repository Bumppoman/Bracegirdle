class AddInvestigativeRegionToCemeteries < ActiveRecord::Migration[5.2]
  def change
    add_column :cemeteries, :investigator_region, :integer
  end
end
