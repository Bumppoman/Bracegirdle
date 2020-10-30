class TrusteesController < ApplicationController
  def create
    @cemetery = Cemetery.find(params[:cemetery_cemid])
    @trustee = @cemetery.trustees.create(trustee_params)
    @response = json_response @trustee
  end
  
  def index
    @trustees = Cemetery.includes(:trustees).find(params[:cemid]).trustees.order(:position, :name)
    
    respond_to do |format|
      format.json do
        output = [
          {
            value: '',
            label: 'Select trustee',
            placeholder: true
          }
        ] + @trustees.map do |trustee|
          {
            value: trustee.id,
            label: "#{trustee.name} (#{trustee.position_name})",
            selected: trustee.id == params[:selected_value].to_i,
            customProperties: {
              trustee: trustee
            }
          }
        end
        
        render json: output.to_json
      end
    end
  end
  
  def show
    @trustee = Trustee.find(params[:id])
    respond_to do |format|
      format.json { render json: @trustee.to_json }
    end
  end

  def update
    @trustee = Trustee.find(params[:id])
    @trustee.update(trustee_params)
    @response = json_response @trustee
  end

  private
  
  def json_response(trustee)
    {
      trusteeId: trustee.id,
      trustee: render_to_string(partial: 'trustees/trustee_row', locals: { trustee: trustee })
    }.to_json
  end

  def trustee_params
    params.require(:trustee).permit(:name, :street_address, :city, :state, :zip, :phone, :email, :position)
  end
end
