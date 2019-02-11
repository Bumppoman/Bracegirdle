class RulesController < ApplicationController
  def create
    @rules = Rules.new(rules_params)
    @rules.update(rules_date_params)
    @rules.rules_documents.attach(params[:rules][:rules_documents])

    begin
      @rules.cemetery = Cemetery.find(params.dig(:rules, :cemetery))
    rescue ActiveRecord::RecordNotFound
      @rules.cemetery = nil
    end

    if @rules.save
      redirect_to @rules
    else
      @title = 'Upload New Rules'
      @breadcrumbs = { 'Upload new rules' => nil }

      render action: :new
    end
  end

  def index
    @region = NAMED_REGIONS.key(params[:region]) || current_user.region
    @rules = Rules.where(cemetery: Cemetery.where(county: REGIONS[@region]))

    @title = "Rules Pending Approval for #{helpers.named_region @region} Region"
    @breadcrumbs = { 'Rules pending approval' => nil }
  end

  def new
    @rules = Rules.new(submission_date: Date.current.strftime('%m/%d/%Y'), request_by_email: false, sender_state: 'NY')

    @title = 'Upload New Rules'
    @breadcrumbs = { 'Upload new rules' => nil }
  end

  def show
    @rules = Rules.with_attached_rules_documents.find(params[:id])
    @documents = @rules.rules_documents.clone.to_a
    @revisions = @documents.length
    @current_revision = @documents.pop

    @title = "Review Rules for #{@rules.cemetery.name}"
  end

  def upload_revision
    @rules = Rules.find(params[:id])
    @rules.update(rules_date_params)
    @rules.rules_documents.attach(params[:rules][:rules_documents])

    if @rules.save
      redirect_to rule_path(@rules)
    else
      @title = "Review Rules for #{@rules.cemetery.name}"
      @documents = @rules.rules_documents.clone.to_a
      @revisions = @documents.length
      @current_revision = @documents.pop

      render :show
    end
  end

  private

  def rules_params
    params.require(:rules).permit(:request_by_email, :sender, :sender_email, :sender_street_address, :sender_city, :sender_state, :sender_zip)
  end

  def rules_date_params
    date_params %w(submission_date), params[:rules]
  end
end
