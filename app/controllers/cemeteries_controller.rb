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

    @cemeteries = authorize Cemetery.includes(:towns).where(county: search_county, active: true)

    respond_to do |format|
      format.html
      format.json { render json: @cemeteries.map { |cemetery| { id: cemetery.id, text: "#{cemetery.formatted_cemid} #{cemetery.name}"} }.to_json }
    end
  end

  def index_by_region
    @cemeteries = authorize Cemetery.where(county: REGIONS[REGIONS_BY_KEY[params[:region].to_sym]]).includes(:towns)
  end

  def new
    @cemetery = authorize Cemetery.new
  end

  def overdue_inspections
    if params.has_key? :region
      @cemeteries = authorize Cemetery.where(investigator_region: REGIONS_BY_KEY[params[:region].to_sym], active: true)
        .where('last_inspection_date < ? OR last_inspection_date IS NULL', Date.current - 5.years)
        .order(:last_inspection_date)
    else
      @cemeteries = authorize current_user.overdue_inspections
    end
  end

  def options_for_county
    @cemeteries = authorize Cemetery.where(active: true, county: params[:county])
    output = [
      {
        value: '',
        label: 'Select cemetery',
        placeholder: true
      },
      {
        label: "#{COUNTIES[params[:county].to_i]} County",
        choices: @cemeteries.map do |cemetery|
          {
            value: cemetery.id,
            label: "#{cemetery.formatted_cemid} #{cemetery.name}",
            selected: params[:selected_value] == cemetery.cemid
          }
        end
      }
    ]

    render json: output.to_json
  end

  def show
    @cemetery = authorize Cemetery.includes(
      :approved_rules, :cemetery_locations, :complaints, :current_rules, :notices, :towns, :trustees).find(params[:cemid])
    @complaints = @cemetery.complaints
    @notices = @cemetery.notices
    @rules = @cemetery.approved_rules.order(approval_date: :desc)
  end

  private

  def cemetery_params
    params[:cemetery].permit(:cemid, :name, :county, :active, town_ids: [])
  end
end
