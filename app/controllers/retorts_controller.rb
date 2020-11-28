class RetortsController < ApplicationController
  def create
    @retort = authorize Retort.new(retort_params)
    @retort.crematory_cemid = params[:crematory_cemid]
    @retort.retort_model_id = params[:retort][:retort_model]
    @retort.save
  end
  
  def show
    @retort = authorize Retort.find(params[:id])
    
    respond_to do |format|
      format.json {
        render json: @retort.to_json
      }
    end
  end
  
  def update
    @retort = authorize Retort.find(params[:id])
    @retort.update(retort_params)
  end
  
  private
  
  def retort_params
    params.require(:retort).permit(:installation_date, :decommission_date, :notes)
  end
end
