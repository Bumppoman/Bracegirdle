class CemeteriesController < ApplicationController
  def create
    @cemetery = authorize Cemetery.new(cemetery_params)

    # Separate latitude and longitude
    latitude, longitude = params[:location].split(',')
    location = Location.new(latitude: latitude, longitude: longitude)
    @cemetery.locations << location

    @cemetery.save
    redirect_to cemetery_path(@cemetery)
  end

  def index; end

  def list_by_county
    search_county = params[:county]
    @county = COUNTIES[params[:county].to_i]

    @cemeteries = authorize Cemetery.includes(:towns).where(county: search_county, active: true).order(:county, :order_id)

    respond_to do |format|
      format.html
      format.json { render json: @cemeteries.map { |cemetery| { id: cemetery.id, text: "#{cemetery.cemetery_id} #{cemetery.name}"} }.to_json }
    end
  end

  def list_by_region
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
    @cemeteries = authorize Cemetery.where(active: true, county: params[:county]).order(:county, :order_id)
    output = helpers.content_tag('option', 'Select cemetery', :value => '') +
        "\n" +
        helpers.grouped_options_for_select([["#{COUNTIES[params[:county].to_i]} County",  @cemeteries.map {|cemetery| ["#{cemetery.cemetery_id} #{cemetery.name}", cemetery.id]}]], params[:selected_value].split(','))

    render html: output
  end

  def show
    respond_to do |format|
      format.html do
        @cemetery = authorize Cemetery.includes(:complaints, :notices, :trustees).find_by_cemetery_id(params[:cemetery_id])
        @complaints = @cemetery.complaints
        @notices = @cemetery.notices
      end

      format.json do
        @cemetery = authorize Cemetery.find(params[:id])
        render json: @cemetery.to_json(methods: :investigator)
      end
    end
  end

  private

  def cemetery_params
    params[:cemetery].permit(:name, :county, :order_id, :active, town_ids: [])
  end
end
