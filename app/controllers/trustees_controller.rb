class TrusteesController < ApplicationController
  def api_list
    render html: helpers.trustees_for_select(Cemetery.find(params[:id]))
  end

  def create
    # Create person
    @person = Person.new(person_params)
    @person.save

    # Create trustee
    @cemetery = Cemetery.find(params[:cemetery_id])
    @trustee = Trustee.new(trustee_params)
    @trustee.cemetery = @cemetery
    @trustee.person = @person
    @trustee.save

    redirect_to cemetery_trustees_path(@cemetery)
  end

  def edit
    @cemetery = Cemetery.find(params[:cemetery_id])
    @trustee = Trustee.find(params[:id])
    @person = @trustee.person

    @title = "Edit Trustee for #{@cemetery.name}"
    @breadcrumbs = { @cemetery.name => cemetery_trustees_path(@cemetery), 'Edit trustee' => nil }
    render 'people/person_form'
  end

  def new
    @cemetery = Cemetery.find(params[:cemetery_id])
    @trustee = Trustee.new
    @person = Person.new

    @title = "Add New Trustee for #{@cemetery.name}"
    @breadcrumbs = { @cemetery.name => cemetery_trustees_path(@cemetery), 'Add new trustee' => nil }
    render 'people/person_form'
  end

  def update
    @trustee = Trustee.find(params[:id])

    # Update trustee
    @trustee.update(trustee_params)
    @trustee.save

    # Update person
    @trustee.person.update(person_params)
    @trustee.person.save

    redirect_to cemetery_trustees_path(@trustee.cemetery)
  end

  private

  def person_params
    params[:person].permit(:name, :address, :phone_number, :email)
  end

  def trustee_params
    params.permit(:position)
  end
end