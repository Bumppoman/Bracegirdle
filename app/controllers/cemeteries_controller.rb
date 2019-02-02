class CemeteriesController < ApplicationController
  def create
    @cemetery = Cemetery.new(cemetery_params)

    # Separate latitude and longitude
    @cemetery.latitude, @cemetery.longitude = params[:location].split(',')

    @cemetery.save
    redirect_to cemetery_path(@cemetery)
  end

  def create_new_trustee
    # Create person
    @person = Person.new(person_params)
    @person.save

    # Create trustee
    @cemetery = Cemetery.find(params[:id])
    @trustee = Trustee.new(trustee_params)
    @trustee.cemetery = @cemetery
    @trustee.person = @person
    @trustee.save

    redirect_to cemetery_trustees_path(@cemetery)
  end

  def edit_trustee
    @cemetery = Cemetery.find(params[:id])
    @trustee = Trustee.find(params[:trustee])
    @person = @trustee.person

    @title = "Edit Trustee for #{@cemetery.name}"
    @breadcrumbs = { @cemetery.name => cemetery_trustees_path(@cemetery), 'Edit trustee' => nil }
    render 'people/person_form'
  end

  def index; end

  def list_by_county
    @cemeteries = Cemetery.where(county: COUNTIES.key(params[:county].capitalize), active: true).order(:county, :order_id).includes(:town)

    @title = "Cemeteries in #{params[:county].capitalize} County"
    @breadcrumbs = { 'All cemeteries' => '#', "#{params[:county].capitalize} County" => nil }

    render :index
  end

  def list_by_region
    @cemeteries = Cemetery.where(county: REGIONS[params[:region]]).includes(:town).find_each

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

    @title = 'Add new cemetery'
    @breadcrumbs = { 'Add New Cemetery' => nil }
  end

  def new_trustee
    @cemetery = Cemetery.find(params[:id])
    @trustee = Trustee.new
    @person = Person.new

    @title = "Add New Trustee for #{@cemetery.name}"
    @breadcrumbs = { @cemetery.name => cemetery_trustees_path(@cemetery), 'Add new trustee' => nil }
    render 'people/person_form'
  end

  def show
    @cemetery = Cemetery.find(params[:id])

    @title = 'Cemetery Information'
    @breadcrumbs = { 'All cemeteries' => '#', "#{@cemetery.county_name} County" => url_for(controller: :cemeteries, action: :list_by_county, county: @cemetery.county_name.downcase), @cemetery.name => nil }
  end

  def update_trustee
    @trustee = Trustee.find(params[:trustee])

    # Update trustee
    @trustee.update(trustee_params)
    @trustee.save

    # Update person
    @trustee.person.update(person_params)
    @trustee.person.save

    redirect_to cemetery_trustees_path(@trustee.cemetery)
  end

  private

  def cemetery_params
    params[:cemetery].permit(:name, :county, :order_id, :active, :town_id)
  end

  def person_params
    params[:person].permit(:name, :address, :phone_number, :email)
  end

  def trustee_params
    params.permit(:position)
  end
end
