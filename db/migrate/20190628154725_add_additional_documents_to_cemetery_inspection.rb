class AddAdditionalDocumentsToCemeteryInspection < ActiveRecord::Migration[6.0]
  def change
    add_column :cemetery_inspections, :additional_documents, :boolean, array: true
  end
end
