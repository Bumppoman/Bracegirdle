class NonComplianceNotices::NotesController < NotesController
  before_action :set_notable

  private
    def set_notable
      @notable = NonComplianceNotice.find(params[:non_compliance_notice_id])
    end
end