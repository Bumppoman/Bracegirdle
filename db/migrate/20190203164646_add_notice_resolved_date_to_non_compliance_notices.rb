class AddNoticeResolvedDateToNonComplianceNotices < ActiveRecord::Migration[5.2]
  def change
    add_column :non_compliance_notices, :notice_resolved_date, :date, after: :follow_up_inspection_date
  end
end
