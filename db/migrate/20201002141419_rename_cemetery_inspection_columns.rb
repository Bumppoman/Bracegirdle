class RenameCemeteryInspectionColumns < ActiveRecord::Migration[6.0]
  def change
    rename_column :cemetery_inspections, :trustee_street_address, :mailing_street_address
    rename_column :cemetery_inspections, :trustee_city, :mailing_city
    rename_column :cemetery_inspections, :trustee_state, :mailing_state
    rename_column :cemetery_inspections, :trustee_zip, :mailing_zip
    rename_column :cemetery_inspections, :trustee_phone, :cemetery_phone
    rename_column :cemetery_inspections, :trustee_email, :cemetery_email
  end
end
