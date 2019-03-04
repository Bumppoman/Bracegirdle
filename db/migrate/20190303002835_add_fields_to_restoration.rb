class AddFieldsToRestoration < ActiveRecord::Migration[5.2]
  def change
    add_column :restoration, :monuments, :integer
    add_column :restoration, :application_form_complete, :boolean, default: false
    add_column :restoration, :legal_notice_cost, :decimal, precision: 9, scale: 2
    add_column :restoration, :legal_notice_newspaper, :text
    add_column :restoration, :legal_notice_format, :boolean, default: false
  end
end
