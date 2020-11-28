class CrematoriesController < ApplicationController
  def create
    @crematory = authorize Crematory.new(crematory_params)
    @crematory.save
    
    redirect_to crematory_path(@crematory)
  end
  
  def index
    @crematories = authorize Crematory.where(active: true)
  end
  
  def new
    @crematory = authorize Crematory.new(state: 'NY')
  end
  
  def show
    @crematory = authorize Crematory.includes(:notices, :operators, retorts: :retort_model).find(params[:cemid])
    @notices = @crematory.notices
  end
  
  private
  
  def crematory_params
    params.require(:crematory).permit(
      :name, :county, :cemid, :street_address, 
      :city, :state, :zip, :phone, :email, :classification
    )
  end
end
