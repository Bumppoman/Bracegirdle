class TrusteesController < ApplicationController
  def api_list
    render html: helpers.trustees_for_select(Cemetery.includes(:trustees).find(params[:id]))
  end

  def create
    @cemetery = Cemetery.find(params[:cemetery_id])
    @trustee = Trustee.new(trustee_params)
    @trustee.cemetery = @cemetery
    @trustee.save

    redirect_to cemetery_trustees_path(@cemetery)
  end

  private

  def trustee_params
    params.require(:trustee).permit(:name, :address, :phone_number, :email, :position)
  end
end