class ChangeCemeteryInspectionElectionToBoolean < ActiveRecord::Migration[6.0]
  def change
    change_column :cemetery_inspections, :election, :boolean
  end
end
