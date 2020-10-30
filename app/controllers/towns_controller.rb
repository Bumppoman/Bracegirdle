class TownsController < ApplicationController
  def index_for_county
    @towns = Town.where(county: params[:county]).order(:name)
    selected = params[:selected_value].split(',')
    output = [
      {
        label: "#{COUNTIES[params[:county].to_i]} County",
        choices: @towns.map do |town|
          {
            value: town.id,
            label: town.name,
            selected: selected.include?(town.id)
          }
        end
      }
    ]

    render json: output.to_json
  end
end
