class EstimatesController < ApplicationController
  def create
    @estimate = Estimate.new(estimate_params)
    @estimate.restoration_id = params[:restoration_id]
    @estimate.contractor_id = Contractor.find(params[:estimate][:contractor]).id

    if @estimate.save
      respond_to do |m|
        m.js
      end
    end
  end

  private
  def estimate_params
    params.require(:estimate).permit(:document, :amount, :warranty, :proper_format)
  end
end
