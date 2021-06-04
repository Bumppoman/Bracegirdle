class Rules::ApprovalsController < ApplicationController
  def approve
    @rules_approval = authorize RulesApproval.includes(:cemetery).find(params[:id])

    # Update rules approval
    @rules_approval.update(
      status: :approved,
      approval_date: Date.current,
      approved_by: current_user
    )
    @rules_approval.investigator ||= current_user
    RulesApprovals::RulesApprovalApprovedEvent.new(@rules_approval, current_user).trigger
    
    # Create rules
    @rules = Rules.new(
      cemetery: @rules_approval.cemetery,
      rules_approval: @rules_approval,
      approval_date: Date.current,
      approved_by: current_user
    )
    @rules.rules_document.attach(@rules_approval.revisions.first.rules_document.blob)
    @rules.save
    
    redirect_to rules_by_date_cemetery_path(cemid: @rules.cemetery_cemid, date: @rules.approval_date.iso8601),
      flash: {
        success: 'You have successfully approved these rules.',
        download_letter: true
      }
  end
  
  def assign
    @rules_approval = authorize RulesApproval.find(params[:id])

    @rules_approval.update(
      status: :pending_review,
      investigator_id: params[:rules_approval][:investigator]
    )
    RulesApprovals::RulesApprovalAssignedEvent.new(@rules_approval, current_user).trigger
    
    redirect_to rules_approval_path(@rules_approval),
      flash: {
        success: 'You have successfully assigned these rules.'
      }
  end
  
  def create
    @rules_approval = authorize RulesApproval.new(rules_params)
    
    # Get cemetery and trustee
    @rules_approval.cemetery = Cemetery.find_by_cemid(params.dig(:rules_approval, :cemetery))
    @rules_approval.trustee = Trustee.find(params[:rules_approval][:trustee])

    unless params[:rules_approval][:investigator].blank?
      @rules_approval.investigator = User.find(params[:rules_approval][:investigator])
      @rules_approval.status = :pending_review
    end

    if @rules_approval.valid? && verify_upload(params[:rules_approval][:rules_document])
      
      # Create rules approval
      @rules_approval.save
      RulesApprovals::RulesApprovalUploadEvent.new(@rules_approval, current_user).trigger
      
      # Create initial revision
      @rules_approval.revisions.create(
        comments: 'Initial revision',
        submission_date: @rules_approval.submission_date,
        status: :received
      )
      @rules_approval.revisions.first.rules_document.attach(params[:rules_approval][:rules_document])
      RulesRevisions::RulesApprovalRevisionUploadedEvent.new(@rules_approval.revisions.first, current_user).trigger
      
      redirect_to rules_approval_path(@rules_approval)
    else
      @rules_approval.cemetery_county = params[:rules_approval][:cemetery_county]
      render action: :new
    end
  end
  
  def download_approval_letter
    @rules_approval = authorize RulesApproval.find(params[:id])

    send_data PDFGenerators::RulesApprovalPDFGenerator.call(@rules_approval).render,
      filename: "Rules-Approval-#{@rules_approval.identifier}.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end
  
  def index
    @rules_approvals = authorize current_user.rules_approvals.includes(:cemetery)
  end
  
  def new
    @rules_approval = authorize RulesApproval.new(
      submission_date: Date.current,
      request_by_email: false,
      sender_state: 'NY',
      investigator: current_user
    )
  end
  
  def recommend_approval
    @rules_approval = authorize RulesApproval.find(params[:id])
    @rules_approval.update(
      status: :approval_recommended,
      investigator: current_user
    )
    
    RulesApprovals::RulesApprovalApprovalRecommendedEvent.new(@rules_approval, current_user).trigger
  end
  
  def show
    @rules_approval = authorize RulesApproval.includes(:cemetery, :investigator, revisions: [rules_document_attachment: :blob])
      .find(params[:id])
    @revisions = @rules_approval.revisions
    @received_revisions = @revisions.select { |revision| revision.received? }
  end
  
  def withdraw
    @rules_approval = authorize RulesApproval.find(params[:id])
    @rules_approval.update(status: :withdrawn)
    
    RulesApprovals::RulesApprovalWithdrawnEvent.new(@rules_approval, current_user).trigger
  end
  
  private
  
  def rules_params
    params.require(:rules_approval).permit(:request_by_email, :sender_email, :sender_street_address, 
      :sender_city, :sender_state, :sender_zip, :submission_date)
  end
  
  def verify_upload(document)
    @rules_approval.errors.add(:revisions, :blank) and return false unless document.present?
    @rules_approval.errors.add(:revisions, :invalid) and return false unless %w(application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document application/pdf).include? document.content_type
    true
  end
end