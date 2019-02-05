class RulesController < ApplicationController
  def index
    @region = NAMED_REGIONS.key(params[:region]) || current_user.region
    @rules = Rules.where(cemetery: Cemetery.where(county: REGIONS[@region]))

    @title = "Rules Pending Approval for #{helpers.named_region @region} Region"
    @breadcrumbs = { 'Rules pending approval' => nil }
  end
end
