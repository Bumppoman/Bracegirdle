class AddRecordKeepingQuestionsToCemeteryInspections < ActiveRecord::Migration[5.2]
  def change
    add_column :cemetery_inspections, :overall_conditions, :text
    add_column :cemetery_inspections, :renovations, :text
    add_column :cemetery_inspections, :annual_meetings, :boolean
    add_column :cemetery_inspections, :annual_meetings_comments, :string
    add_column :cemetery_inspections, :election, :string
    add_column :cemetery_inspections, :number_of_trustees, :integer
    add_column :cemetery_inspections, :burial_permits, :boolean
    add_column :cemetery_inspections, :burial_permits_comments, :string
    add_column :cemetery_inspections, :body_delivery_receipt, :boolean
    add_column :cemetery_inspections, :body_delivery_receipt_comments, :string
    add_column :cemetery_inspections, :deeds_signed, :boolean
    add_column :cemetery_inspections, :deeds_signed_comments, :string
    add_column :cemetery_inspections, :burial_records, :boolean
    add_column :cemetery_inspections, :burial_records_comments, :string
    add_column :cemetery_inspections, :rules_provided, :boolean
    add_column :cemetery_inspections, :rules_provided_comments, :string
    add_column :cemetery_inspections, :rules_approved, :boolean
    add_column :cemetery_inspections, :rules_approved_comments, :string
    add_column :cemetery_inspections, :employees, :boolean
    add_column :cemetery_inspections, :employees_comments, :string
    add_column :cemetery_inspections, :trustees_compensated, :boolean
    add_column :cemetery_inspections, :trustees_compensated_comments, :string
  end
end
