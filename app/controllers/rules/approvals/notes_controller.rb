class Rules::Approvals::NotesController < NotesController
  before_action :set_notable

  private
  def set_notable
    @notable = RulesApproval.find(params[:approval_id])
  end
end