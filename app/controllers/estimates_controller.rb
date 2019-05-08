class EstimatesController < ApplicationController
  def create
    @estimate = Estimate.new(estimate_params)
    @estimate.restoration_id = params[:restoration_id]

    if params[:estimate][:contractor].to_i != 0
      @estimate.contractor = Contractor.find(params[:estimate][:contractor])
    else
      contractor = Contractor.new(name: params[:estimate][:contractor])
      contractor.save
      @estimate.contractor = contractor
    end

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
