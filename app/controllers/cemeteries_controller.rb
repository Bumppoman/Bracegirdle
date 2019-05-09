class CemeteriesController < ApplicationController
  def api_overdue_inspections_by_region

    counts = []
    NAMED_REGIONS.each do |region, name|
      counts << {
        region: name,
        inspections: Cemetery.where(county: REGIONS[region]).where('last_inspection_date > ?', Date.current - 5.years).count
      }
    end

    respond_to do |format|
      format.json { render json: counts.to_json }
    end
  end

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
    search_county = params[:county]
    @county = COUNTIES[params[:county].to_i]

    @cemeteries = Cemetery.includes(:towns).where(county: search_county, active: true).order(:county, :order_id)

    respond_to do |format|
      format.html
      format.json { render json: @cemeteries.map { |cemetery| { id: cemetery.id, text: "#{cemetery.cemetery_id} #{cemetery.name}"} }.to_json }
    end
  end

  def list_by_region
    @cemeteries = Cemetery.where(county: REGIONS[params[:region]]).includes(:towns)
  end

  def new
    @cemetery = Cemetery.new
  end

  def overdue_inspections
    @cemeteries = current_user.overdue_inspections
  end

  def options_for_county
    @cemeteries = Cemetery.where(active: true, county: params[:county]).order(:county, :order_id)
    output = helpers.content_tag('option', 'Select cemetery', :value => '') +
        "\n" +
        helpers.grouped_options_for_select([["#{COUNTIES[params[:county].to_i]} County",  @cemeteries.map {|cemetery| ["#{cemetery.cemetery_id} #{cemetery.name}", cemetery.id]}]], params[:selected_value].split(','))

    render html: output
  end

  def show
    @cemetery = Cemetery.includes(:complaints, :notices, :trustees).find(params[:id])
    respond_to do |format|
      format.html {
        @complaints = @cemetery.complaints
        @notices = @cemetery.notices
      }
      format.json { render json: @cemetery.to_json(methods: :investigator) }
    end
  end

  private

  def cemetery_params
    params[:cemetery].permit(:name, :county, :order_id, :active, town_ids: [])
  end
end
