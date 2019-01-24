class AddNoticeNumberToNonComplianceNotices < ActiveRecord::Migration[5.2]
  def change
    add_column :non_compliance_notices, :notice_number, :string, before: :cemetery_id
  end
end
