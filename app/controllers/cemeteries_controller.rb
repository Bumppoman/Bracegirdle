class CemeteriesController < ApplicationController
  def create
    @cemetery = Cemetery.new(cemetery_params)

    # Separate latitude and longitude
    latitude, longitude = params[:location].split(',')
    location = Location.new(latitude: latitude, longitude: longitude)
    @cemetery.locations << location

    @cemetery.save
    redirect_to cemetery_path(@cemetery)
  end

  def index; end

  def list_by_county
    if /\d{1,2}/ =~ params[:county]
      search_county = params[:county]
      @county = COUNTIES[params[:county]]
    else
      search_county = COUNTIES.key(params[:county].capitalize)
      @county = params[:county].capitalize
    end

    @cemeteries = Cemetery.includes(:towns).where(county: search_county, active: true).order(:county, :order_id)

    respond_to do |format|
      format.html
      format.json { render json: @cemeteries.map { |cemetery| { id: cemetery.id, text: "#{cemetery.cemetery_id} #{cemetery.name}"} }.to_json }
    end
  end

  def list_by_region
    @cemeteries = Cemetery.where(county: REGIONS[params[:region]]).includes(:towns).find_each
  end

  def new
    @cemetery = Cemetery.new
  end

  def options_for_county
    @cemeteries = Cemetery.where(active: true, county: params[:county]).order(:county, :order_id)
    output = helpers.content_tag('option', 'Select cemetery', :value => '') +
        "\n" +
        helpers.grouped_options_for_select([["#{COUNTIES[params[:county].to_i]} County",  @cemeteries.map {|cemetery| ["#{cemetery.cemetery_id} #{cemetery.name}", cemetery.id]}]], params[:selected_value].split(','))

    render html: output
  end

  def show
    @cemetery = Cemetery.includes(:complaints, trustees: :person).find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @cemetery.to_json(methods: :investigator) }
    end
  end

  private

  def cemetery_params
    params[:cemetery].permit(:name, :county, :order_id, :active, town_ids: [])
  end
end
