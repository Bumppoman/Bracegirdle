class RulesController < ApplicationController
  def create
    @rules = authorize Rules.new

    # Get investigator if one was selected
    @rules.assign_attributes(
      cemetery_cemid: params[:rules][:cemetery],
      cemetery_county: params[:rules][:cemetery_county],
      approved_by_id: params[:rules][:approved_by],
      approval_date: params[:rules][:approval_date]
    )

    if @rules.valid? && verify_upload(params[:rules][:rules_document])
      @rules.save
      @rules.rules_document.attach(params[:rules][:rules_document])
      redirect_to rules_by_date_cemetery_path(cemid: @rules.cemetery_cemid, date: @rules.approval_date.iso8601)
    else
      render :new
    end
  end
  
  def new
    @rules = authorize Rules.new  
  end
  
  def show
    if params.key? :cemid
      @rules = authorize Rules.order(approval_date: :desc).joins(:cemetery).where(cemeteries: { cemid: params[:cemid] }).first
    else
      @rules = authorize Rules.with_attached_rules_document.find(params[:id])
    end
  end
  
  def show_for_date
    @rules = authorize Rules.with_attached_rules_document.find_by(approval_date: params[:date], cemetery_cemid: params[:cemid])
    render :show
  end
  
  private
  
  def verify_upload(document)
    @rules.errors.add(:rules_document, :blank) and return false unless document.present?
    @rules.errors.add(:rules_document, :invalid) and return false unless %w(application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document application/pdf).include? document.content_type
    true
  end
end
