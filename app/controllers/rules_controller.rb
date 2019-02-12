class RulesController < ApplicationController
  def create
    @rules = Rules.new(rules_params)
    @rules.assign_attributes(rules_date_params)

    begin
      @rules.cemetery = Cemetery.find(params.dig(:rules, :cemetery))
    rescue ActiveRecord::RecordNotFound
      @rules.cemetery = nil
    end

    if @rules.valid? && verify_upload(params[:rules][:rules_documents])
      @rules.save
      @rules.rules_documents.attach(params[:rules][:rules_documents])
      redirect_to @rules
    else
      @title = 'Upload New Rules'
      @breadcrumbs = { 'Upload new rules' => nil }
      @rules.cemetery_county = params[:rules][:cemetery_county]

      render action: :new
    end
  end

  def create_old_rules
    @rules = Rules.new(rules_date_params)

    begin
      @rules.cemetery = Cemetery.find(params.dig(:rules, :cemetery))
    rescue ActiveRecord::RecordNotFound
      @rules.cemetery = nil
    end

    investigator = params[:rules][:approved_by].present? ? User.find(params[:rules][:approved_by]) : nil
    @rules.assign_attributes(
      cemetery_county: params[:rules][:cemetery_county],
      approved_by: investigator,
      status: 3
    )

    if @rules.valid? && verify_upload(params[:rules][:rules_documents])
      @rules.save
      @rules.rules_documents.attach(params[:rules][:rules_documents])
      redirect_to @rules
    else
      render :upload_old_rules
    end
  end

  def index
    @region = NAMED_REGIONS.key(params[:region]) || current_user.region
    @rules = Rules.active_for(current_user)

    @title = "Rules Pending Approval for #{helpers.named_region @region} Region"
    @breadcrumbs = { 'Rules pending approval' => nil }
  end

  def new
    @rules = Rules.new(submission_date: Date.current.strftime('%m/%d/%Y'), request_by_email: false, sender_state: 'NY')

    @title = 'Upload New Rules'
    @breadcrumbs = { 'Upload new rules' => nil }
  end

  def review
    @rules = Rules.find(params[:id])

    if params.key?(:approve_rules)
      @rules.update(
        status: :approved,
        approval_date: Date.current,
        approved_by: current_user
      )
      @rules.rules_documents.order(id: :desc).offset(1).destroy_all
    elsif params.key?(:request_revision)
      @rules.status = :revision_requested
    end

    @rules.save

    redirect_to cemetery_rules_path(@rules.cemetery) and return
  end

  def show
    @rules = Rules.with_attached_rules_documents.find(params[:id])

    if @rules.approved?
      @title = "Rules for #{@rules.cemetery.name}"
      @breadcrumbs = { @rules.cemetery.name => cemetery_path(@rules.cemetery), 'Rules and Regulations' => nil }

      render :show_approved
    else
      @documents = @rules.rules_documents.clone.to_a
      @revisions = @documents.length
      @current_revision = @documents.pop

      @title = "Review Rules for #{@rules.cemetery.name}"
      @breadcrumbs = { 'Rules pending approval' => rules_path, @title => nil }
    end
  end

  def show_approved
    @rules = Rules.where(status: 3).order(approval_date: :desc).joins(:cemetery).where(cemeteries: {id: params[:id] }).first

    @title = "Rules for #{@rules.cemetery.name}"
    @breadcrumbs = { @rules.cemetery.name => cemetery_path(@rules.cemetery), 'Rules and Regulations' => nil }
  end

  def upload_old_rules
    @rules = Rules.new(status: 3)

    @title = "Upload Previously Approved Rules"
    @breadcrumbs = { 'Upload previously approved rules' => nil }
  end

  def upload_revision
    @rules = Rules.find(params[:id])
    @rules.status = :received
    @rules.assign_attributes(rules_date_params)

    if @rules.valid? && verify_upload(params[:rules][:rules_documents])
      @rules.save
      @rules.rules_documents.attach(params[:rules][:rules_documents])
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
    date_params %w(submission_date approval_date), params[:rules]
  end

  def verify_upload(document)
    @rules.errors.add(:rules_documents, :blank) and return false unless document.present?
    @rules.errors.add(:rules_documents, :invalid) and return false unless %w(application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document application/pdf).include? document.content_type
    true
  end
end
