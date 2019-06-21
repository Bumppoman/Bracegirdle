class AddAdditionalCommentsToCemeteryInspection < ActiveRecord::Migration[6.0]
  def change
    add_column :cemetery_inspections, :additional_comments, :text
  end
end
