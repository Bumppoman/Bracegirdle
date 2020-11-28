class Rules::RevisionsController < ApplicationController
  def create
    @rules_approval = authorize(
      RulesApproval.includes(:revisions).find(params[:approval_id]), :request_revision?)
    @revision = @rules_approval.revisions.new(comments: params[:revision][:comments])
    
    if @revision.valid?
      
      # Create the revision
      @revision.save
      RulesRevisions::RulesApprovalRevisionCreatedEvent.new(@revision, current_user).trigger

      # Update the rules approval
      @rules_approval.update(status: :revision_requested)
      RulesApprovals::RulesApprovalRevisionRequestedEvent.new(@rules_approval, current_user).trigger
      
      respond_to :js
    end
  end
  
  def receive
    @rules_approval = authorize(
      RulesApproval.includes(:revisions).find(params[:approval_id]), :receive_revision?)
    @revision = @rules_approval.revisions.where(status: :requested).first
    
    if @revision.valid? && verify_upload(params[:revision][:rules_document])
      
      # Update the revision
      @revision.rules_document.attach(params[:revision][:rules_document])
      @revision.update(submission_date: params[:revision][:submission_date], status: :received)
      RulesRevisions::RulesApprovalRevisionUploadedEvent.new(@revision, current_user).trigger
      
      # Update the rules approval
      @rules_approval.update(status: :pending_review)
      RulesApprovals::RulesApprovalRevisionReceivedEvent.new(@rules_approval, current_user).trigger
      
      respond_to :js
    else
      head :no_content
    end
  end
  
  private
  
  def verify_upload(document)
    @revision.errors.add(:rules_document, :blank) and return false unless document.present?
    @revision.errors.add(:rules_document, :invalid) and return false unless %w(application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document application/pdf).include? document.content_type
    true
  end
end