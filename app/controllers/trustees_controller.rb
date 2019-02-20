class TrusteesController < ApplicationController
  def api_list
    render html: helpers.trustees_for_select(Cemetery.find(params[:id]))
  end
end