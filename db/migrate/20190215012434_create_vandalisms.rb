class CreateVandalisms < ActiveRecord::Migration[5.2]
  def change
    create_table :vandalisms do |t|
      t.integer :type
      t.references :cemetery
      t.integer :trustee_id
      t.decimal :amount, precision: 9, scale: 2
      t.date :submission_date
      t.date :field_visit_date
      t.date :recommendation_date
      t.date :supervisor_review_date
      t.date :award_date
      t.date :completion_date
      t.date :follow_up_date
      t.integer :status
      t.timestamps
    end
  end
end
