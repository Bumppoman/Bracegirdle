class RulesController < ApplicationController
  def approve
    @rules = authorize Rules.find(params[:id])

    @rules.update(
      status: :approved,
      approval_date: Date.current,
      investigator: current_user
    )
    @rules.rules_documents.order(id: :desc).offset(1).destroy_all

    Rules::RulesApprovalEvent.new(@rules, current_user).trigger

    redirect_to rules_path(@rules, download_rules_approval: true)
  end

  def assign
    @rules = authorize Rules.find(params[:id])

    @rules.update(
      status: :pending_review,
      investigator_id: params[:rules][:investigator]
    )
    Rules::RulesAssignedEvent.new(@rules, current_user).trigger

    redirect_to review_rules_path(@rules)
  end

  def create
    @rules = authorize Rules.new(rules_params)
    @rules.assign_attributes(rules_date_params)

    begin
      @rules.cemetery = Cemetery.find(params.dig(:rules, :cemetery))
    rescue ActiveRecord::RecordNotFound
      @rules.cemetery = nil
    end

    unless params[:rules][:investigator].blank?
      @rules.investigator = User.find(params[:rules][:investigator])
      @rules.status = :pending_review
    end

    if @rules.valid? && verify_upload(params[:rules][:rules_documents])
      @rules.save
      @rules.rules_documents.attach(params[:rules][:rules_documents])

      Rules::RulesUploadEvent.new(@rules, current_user).trigger
      redirect_to review_rules_path(@rules)
    else
      @rules.cemetery_county = params[:rules][:cemetery_county]
      render action: :new
    end
  end

  def create_old_rules
    @rules = authorize Rules.new(rules_date_params)

    begin
      @rules.cemetery = Cemetery.find(params.dig(:rules, :cemetery))
    rescue ActiveRecord::RecordNotFound
      @rules.cemetery = nil
    end

    investigator = params[:rules][:investigator].present? ? User.find(params[:rules][:investigator]) : nil
    @rules.assign_attributes(
      cemetery_county: params[:rules][:cemetery_county],
      investigator: investigator,
      status: :approved
    )

    if @rules.valid? && verify_upload(params[:rules][:rules_documents])
      @rules.save
      @rules.rules_documents.attach(params[:rules][:rules_documents])
      redirect_to @rules
    else
      render :upload_old_rules
    end
  end

  def download_approval
    @rules = authorize Rules.find(params[:id])

    send_data PDFGenerators::RulesApprovalPDFGenerator.call(@rules).render,
      filename: "Rules-Approval-#{@rules.identifier}.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end

  def index
    @rules = authorize current_user.rules.includes(:cemetery)
  end

  def new
    @rules = authorize Rules.new(
        submission_date: Date.current.strftime('%m/%d/%Y'),
        request_by_email: false,
        sender_state: 'NY',
        investigator: current_user
    )
  end

  def request_revision
    @rules = authorize Rules.find(params[:id])

    @rules.update(status: :revision_requested)
    Rules::RulesRevisionRequestedEvent.new(@rules, current_user).trigger

    redirect_to review_rules_path(@rules)
  end

  def review
    @rules = authorize Rules.with_attached_rules_documents.find(params[:id])

    @documents = @rules.rules_documents.clone.to_a
    @revisions = @documents.length
    @current_revision = @documents.pop
  end

  def show
    if params.key? :cemetery_id
      @cemetery = Cemetery.find_by_cemetery_id(params[:cemetery_id])
      @rules = authorize Rules.approved.order(approval_date: :desc).joins(:cemetery).where(cemeteries: { id: @cemetery.id }).first
    else
      @rules = authorize Rules.with_attached_rules_documents.find(params[:id])
    end
  end

  def upload_old_rules
    @rules = authorize Rules.new
  end

  def upload_revision
    @rules = authorize Rules.find(params[:id])
    old_submission_date = @rules.submission_date
    @rules.assign_attributes(rules_date_params)

    if @rules.valid? && verify_upload(params[:rules][:rules_documents])
      first_revision = @rules.rules_documents.last
      old_submission_time = first_revision.created_at
      first_revision.created_at = Time.mktime(
          old_submission_date.year, old_submission_date.month,
          old_submission_date.day, old_submission_time.hour,
          old_submission_time.min, old_submission_time.sec)
      first_revision.save

      @rules.save
      @rules.rules_documents.attach(params[:rules][:rules_documents])

      Rules::RulesRevisionReceivedEvent.new(@rules, current_user).trigger
      redirect_to review_rules_path(@rules)
    else
      @documents = @rules.rules_documents.clone.to_a
      @revisions = @documents.length
      @current_revision = @documents.pop

      render :review
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
