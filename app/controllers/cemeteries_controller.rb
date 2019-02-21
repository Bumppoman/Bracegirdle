class CemeteriesController < ApplicationController
  def create
    @cemetery = Cemetery.new(cemetery_params)

    # Separate latitude and longitude
    @cemetery.latitude, @cemetery.longitude = params[:location].split(',')

    @cemetery.save
    redirect_to cemetery_path(@cemetery)
  end

  def index; end

  def list_by_county
    if /\d{1,2}/ =~ params[:county]
      search_county = params[:county]
    else
      search_county = COUNTIES.key(params[:county].capitalize)
    end

    @cemeteries = Cemetery.where(county: search_county, active: true).order(:county, :order_id).includes(:towns)

    @title = "Cemeteries in #{params[:county].capitalize} County"
    @breadcrumbs = { 'All cemeteries' => '#', "#{params[:county].capitalize} County" => nil }

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @cemeteries.map { |cemetery| { id: cemetery.id, text: "#{cemetery.cemetery_id} #{cemetery.name}"} }.to_json }
    end
  end

  def list_by_region
    @cemeteries = Cemetery.where(county: REGIONS[params[:region]]).includes(:towns).find_each

    @title = "Cemeteries in the #{params[:region].capitalize} Region"
    @breadcrumbs = { 'All cemeteries' => '#', "#{params[:region].capitalize} Region" => nil }

    render :index
  end

  def new
    @cemetery = Cemetery.new

    @towns = Town.all.order(:county, :name).group_by(&:county).map do |county, towns|
      [
        "#{COUNTIES[county]} County", towns.map { |town| [town.name, town.id] }.sort do |a, b|
          a[0][0] <=> b[0][0]
        end
      ]
    end

    @title = 'Add New Cemetery'
    @breadcrumbs = { 'Add new cemetery' => nil }
  end

  def options_for_county
    @cemeteries = Cemetery.where(active: true, county: params[:county]).order(:county, :order_id)
    output = helpers.content_tag('option', 'Select cemetery', :value => '') +
        "\n" +
        helpers.grouped_options_for_select([["#{COUNTIES[params[:county].to_i]} County",  @cemeteries.map {|cemetery| ["#{cemetery.cemetery_id} #{cemetery.name}", cemetery.id]}]], params[:selected_value].split(','))

    render html: output
  end

  def show
    @cemetery = Cemetery.includes(:complaints, :trustees).find(params[:id])

    @title = 'Cemetery Information'
    @breadcrumbs = { 'All cemeteries' => '#', "#{@cemetery.county_name} County" => url_for(controller: :cemeteries, action: :list_by_county, county: @cemetery.county_name.downcase), @cemetery.name => nil }

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
