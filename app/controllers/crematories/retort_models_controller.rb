class Crematories::RetortModelsController < ApplicationController
  def create
    @retort_model = authorize RetortModel.new(retort_model_params)
    @retort_model.save
  end
  
  def index
    @retort_models = authorize RetortModel.all.order(:name)
    
    respond_to do |format|
      if params.include?(:as_options)
        format.json { 
          render json: { 
            options: helpers.retort_model_options(@retort_models, params[:selected]) 
          }.to_json 
        }
      end
    end
  end
  
  private
  
  def retort_model_params
    params.require(:retort_model).permit(:manufacturer, :name, :maximum_throughput)
  end
end
