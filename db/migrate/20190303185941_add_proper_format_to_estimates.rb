class AddProperFormatToEstimates < ActiveRecord::Migration[5.2]
  def change
    add_column :estimates, :proper_format, :boolean
  end
end
