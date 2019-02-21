class TownsController < ApplicationController
  def options_for_county
    @towns = Town.where(county: params[:county]).order(:name)
    output = helpers.content_tag('option', 'Select town', :value => '') +
        "\n" +
        helpers.grouped_options_for_select([["#{COUNTIES[params[:county].to_i]} County",  @towns.map {|town| [town.name, town.id]}]], params[:selected_value])
    render html: output
  end
end