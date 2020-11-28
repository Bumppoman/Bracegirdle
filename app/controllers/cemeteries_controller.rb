class CemeteriesController < ApplicationController
  def create
    @cemetery = authorize Cemetery.new(cemetery_params)
    @cemetery.save

    # Save the cemetery's initial location
    latitude, longitude = params[:cemetery][:location].split(',')
    @cemetery.cemetery_locations.create(latitude: latitude, longitude: longitude)

    redirect_to cemetery_path(@cemetery)
  end

  def index
    @cemeteries = authorize Cemetery.includes(:towns).where(active: true)
  end

  def index_by_county
    search_county = params[:county]
    @county = COUNTIES[params[:county].to_i]
    @cemeteries = authorize Cemetery.where(county: search_county, active: true)

    respond_to do |format|
      format.html do
        @cemeteries = @cemeteries.includes(:towns)  
      end
      
      format.json do
        if params[:options] == 'options'          
          render json: 
            [
              {
                value: '',
                label: 'Select cemetery',
                placeholder: true
              },
              {
                label: "#{@county} County",
                choices: @cemeteries.map do |cemetery|
                  {
                    value: cemetery.id,
                    label: "#{cemetery.formatted_cemid} #{cemetery.name}",
                    selected: params[:selected_value] == cemetery.cemid
                  }
                end
              }
            ].to_json
        end
      end
    end
  end

  def index_by_region
    @cemeteries = authorize Cemetery.where(county: REGIONS[REGIONS_BY_KEY[params[:region].to_sym]]).includes(:towns)
  end
  
  def index_with_overdue_inspections
    query = authorize Cemetery.where(active: true)
      .where('last_inspection_date < ? OR last_inspection_date IS NULL', Date.current - 5.years)
      .order(:last_inspection_date)
    
    if params['type'] === 'region'
      @cemeteries = query.where(investigator_region: REGIONS_BY_KEY[params[:region].to_sym])
    elsif current_user.investigator?
      @cemeteries = authorize current_user.overdue_inspections
    else
      @cemeteries = query
    end
  end

  def new
    @cemetery = authorize Cemetery.new
  end

  def show
    @cemetery = authorize Cemetery.includes(
      :approved_rules, :cemetery_locations, :current_rules, :towns, :trustees, complaints: :cemetery, notices: :cemetery)
      .find(params[:cemid])
    @complaints = @cemetery.complaints
    @notices = @cemetery.notices
    @rules = @cemetery.approved_rules.order(approval_date: :desc)
  end

  private

  def cemetery_params
    params[:cemetery].permit(:cemid, :name, :county, :active, town_ids: [])
  end
end
