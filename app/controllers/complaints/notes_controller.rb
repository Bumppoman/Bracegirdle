class Complaints::NotesController < NotesController
  before_action :set_notable

  private
  def set_notable
    @notable = Complaint.find(params[:complaint_id])
  end
end