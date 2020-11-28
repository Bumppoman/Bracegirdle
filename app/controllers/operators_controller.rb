class OperatorsController < ApplicationController
  def create
    @operator = authorize Operator.new(operator_params)
    @operator.crematory_cemid = params[:crematory_cemid]
    @operator.save
  end
  
  def show
    @operator = authorize Operator.find(params[:id])
    
    respond_to do |format|
      format.json { render json: @operator.to_json }
    end
  end
  
  def update
    @operator = authorize Operator.find(params[:id])
    @operator.update(operator_params)
  end
  
  private
  
  def operator_params
    params.require(:operator).permit(:name, :certification_date, :certification_expiration_date, :notes)
  end
end
