class AddInformationToComplaints < ActiveRecord::Migration[5.2]
  def change
    add_column :complaints, :lot_location, :string
    add_column :complaints, :name_on_deed, :string
    add_column :complaints, :relationship, :string
    add_column :complaints, :ownership_type, :integer
    add_column :complaints, :date_of_event, :date
    add_column :complaints, :date_complained_to_cemetery, :date
    add_column :complaints, :person_contacted, :string
    add_column :complaints, :manner_of_contact, :string
    add_column :complaints, :attorney_contacted, :boolean
    add_column :complaints, :court_action_pending, :boolean
    add_column :complaints, :form_of_relief, :string
    add_column :complaints, :receiver, :integer
    add_column :complaints, :date_acknowledged, :date
    add_column :complaints, :investigation_required, :boolean
    add_column :complaints, :investigator, :integer
    add_column :complaints, :investigation_begin_date, :date
    add_column :complaints, :investigation_completion_date, :date
    add_column :complaints, :recommendation_date, :date
    add_column :complaints, :disposition, :text
  end
end
