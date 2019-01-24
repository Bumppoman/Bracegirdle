class CreateNonComplianceNotices < ActiveRecord::Migration[5.2]
  def change
    create_table :non_compliance_notices do |t|
      t.references :cemetery, foreign_key: true
      t.references :user, foreign_key: true
      t.string :served_on_name
      t.string :served_on_title
      t.string :served_on_street_address
      t.string :served_on_city
      t.string :served_on_state
      t.string :served_on_zip
      t.text :law_sections
      t.text :specific_information
      t.text :notes
      t.date :violation_date
      t.date :response_required_date
      t.date :response_received_date
      t.date :follow_up_inspection_date
      t.integer :status
      t.timestamps
    end
  end
end
