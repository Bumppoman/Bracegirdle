module BoardApplications::Restorations
  class ContractorsController < BoardApplications::RestorationsController
    def create
      @contractor = Contractor.new(contractor_params)
      @contractor.save
    end
    
    def index
      @contractors = Contractor.active
      respond_to do |f|
        f.html
        f.json { render json: Contractor.all.map { |c| { label: c.name, value: c.id } }.to_json }
      end
    end
    
    def show
      @contractor = Contractor.find(params[:id])
      
      respond_to do |f|
        f.json { render json: @contractor.to_json }
      end
    end
    
    def update
      @contractor = authorize Contractor.find(params[:id])
      @contractor.update(contractor_params)
    end
    
    private
    
    def contractor_params
      params.require(:contractor).permit(:city, :county, :name, :phone, :state, :street_address, :zip)
    end
  end
end