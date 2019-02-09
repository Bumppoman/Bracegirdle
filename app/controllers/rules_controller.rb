class RulesController < ApplicationController
  def index
    @region = NAMED_REGIONS.key(params[:region]) || current_user.region
    @rules = Rules.where(cemetery: Cemetery.where(county: REGIONS[@region]))

    @title = "Rules Pending Approval for #{helpers.named_region @region} Region"
    @breadcrumbs = { 'Rules pending approval' => nil }
  end

  def new
    @rules = Rules.new(submission_date: Date.current, email: false, sender_state: 'NY')

    @title = 'Upload New Rules'
  end

  def show
  end

  private

  def rules_params
    params.require(:rules).permit(:cemetery, rule_documents: [])
  end
end
