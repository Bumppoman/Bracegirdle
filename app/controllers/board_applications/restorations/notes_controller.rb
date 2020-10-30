class BoardApplications::Restorations::NotesController < NotesController
  before_action :set_notable

  private
  def set_notable
    @notable = Restoration.find(params[:abandonment_id] || params[:hazardous_id] || params[:vandalism_id])
  end
end