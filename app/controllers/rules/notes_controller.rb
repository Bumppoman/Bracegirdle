class Rules::NotesController < NotesController
  before_action :set_notable

  private
  def set_notable
    @notable = Rules.find(params[:rules_id])
  end
end