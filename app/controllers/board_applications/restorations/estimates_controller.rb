module BoardApplications::Restorations
  class EstimatesController < ApplicationController
    def create
      @estimate = Estimate.new(estimate_params)
      @estimate.restoration_id = params["#{params[:estimate][:restoration_type]}_id"]
      @estimate.contractor = Contractor.find(params[:estimate][:contractor])

      if @estimate.save
        respond_to :js
      end
    end

    private
    
    def estimate_params
      params.require(:estimate).permit(:document, :amount, :warranty, :proper_format)
    end
  end
end