require 'net/http'

class RestorationController < ApplicationController
  include Permissions

  before_action do
    stipulate :must_be_investigator
  end

  def create
    @restoration = model.new(application_create_params)

    # Add new trustee if necessary
    trustee = Trustee.find_or_create_by(
      name: params[@restoration.to_sym][:trustee_name],
      cemetery_id: params[@restoration.to_sym][:cemetery])
    trustee.update(position: params[@restoration.to_sym][:trustee_position])

    @restoration.assign_attributes(
      cemetery_id: params[@restoration.to_sym][:cemetery],
      investigator_id: params[@restoration.to_sym][:investigator],
      trustee_name: trustee.name,
      trustee_position: trustee.position,
      submission_date: date_params([:submission_date], params[@restoration.to_sym])[:submission_date]
    )

    if @restoration.save
      Restoration::RestorationReceivedEvent.new(@restoration, current_user).trigger
      redirect_to @restoration
    else
      @page_info = self.class::PAGE_INFO[:new]
      render :new
    end
  end

  def finish_processing
    @restoration = model.find(params[:id])

    if current_user.supervisor?
      @restoration.update(
        status: :reviewed,
        recommendation_date: Date.current,
        supervisor_review_date: Date.current
      )
      Restoration::RestorationReviewedEvent.new(@restoration, current_user).trigger
    else
      @restoration.update(
        status: :processed,
        recommendation_date: Date.current
      )
      Restoration::RestorationProcessedEvent.new(@restoration, current_user).trigger
    end
  end

  def index
    if current_user.supervisor?
      @applications = model.includes(:cemetery, :status_changes).where(investigator: current_user).or(
          model.includes(:cemetery, :status_changes).processed)
    else
      @applications = model.includes(:cemetery, :status_changes).where(investigator: current_user)
    end
  end

  def new
    @restoration = model.new
    @page_info = self.class::PAGE_INFO[:new]
  end

  def process_restoration
    @restoration = model.includes(
        application_form_attachment: :blob,
        estimates: [:contractor, document_attachment: :blob],
        legal_notice_attachment: :blob)
      .find(params[:id])
    @contractors = Contractor.all.order(:name)
  end

  def return_to_investigator
    @restoration = model.find(params[:id])
    @restoration.update(status: :received)
    Restoration::RestorationReturnedEvent.new(@restoration, current_user).trigger
  end

  def review
    @restoration = model.includes(estimates: :contractor).find(params[:id])
  end

  def send_to_board
    @restoration = model.find(params[:id])
    @restoration.update(status: :reviewed)
    Restoration::RestorationReviewedEvent.new(@restoration, current_user).trigger
  end

  def show
    @restoration = model.includes(estimates: :contractor).find(params[:id])

    redirect_to self.send("process_#{@restoration.type.downcase}_path") if @restoration.received? && @restoration.investigator == current_user
  end

  def upload_application
    @restoration = model.find(params[:id])
    @restoration.update(
      application_form: params[@restoration.to_sym][:application_form],
      monuments: params[@restoration.to_sym][:monuments],
      application_form_complete: params[@restoration.to_sym][:application_form_complete],
      field_visit_date: date_params([:field_visit_date], params[@restoration.to_sym])[:field_visit_date]
    )
  end

  def upload_legal_notice
    @restoration = model.find(params[:id])
    @restoration.update(
      legal_notice: params[@restoration.to_sym][:legal_notice],
      legal_notice_newspaper: params[@restoration.to_sym][:legal_notice_newspaper],
      legal_notice_cost: params[@restoration.to_sym][:legal_notice_cost],
      legal_notice_format: params[@restoration.to_sym][:legal_notice_format]
    )
  end

  def upload_previous
    @restoration = model.find(params[:id])
    @restoration.update(
      previous_report: params[@restoration.to_sym][:previous_report],
      previous_exists: params[@restoration.to_sym][:previous_exists],
      previous_type: params[@restoration.to_sym][:previous_type],
      previous_date: params[@restoration.to_sym][:previous_date]
    )
  end

  def view_application_form
    @restoration = model.find(params[:id])
    @portion = 'Application Form'
    @file = @restoration.application_form
    render 'view_portion'
  end

  def view_combined
    @restoration = model.find(params[:id])
    output = CombinePDF.new
    output << CombinePDF.parse(generate_report.render)

    # Include application
    output << CombinePDF.parse(ExhibitSheetPdf.new({ exhibit: 'A' }).render)
    output << CombinePDF.load(ActiveStorage::Blob.service.send(:path_for, @restoration.application_form.key))

    # Include estimates
    exhibit_letters = ('B'..'Z').to_a
    exhibits = @restoration.estimates.length
    current = 0
    while current < exhibits
      output << CombinePDF.parse(ExhibitSheetPdf.new({ exhibit: exhibit_letters[current]}).render)
      output << CombinePDF.load(ActiveStorage::Blob.service.send(:path_for, @restoration.estimates[current].document.key))
      current += 1
    end

    # Include legal notice
    output << CombinePDF.parse(ExhibitSheetPdf.new({ exhibit: exhibit_letters[current]}).render)
    output << CombinePDF.load(ActiveStorage::Blob.service.send(:path_for, @restoration.legal_notice.key))

    # Include previous report if applicable
    if @restoration.previous_exists?
      current += 1
      output << CombinePDF.parse(ExhibitSheetPdf.new({ exhibit: exhibit_letters[current]}).render)
      output << CombinePDF.load(ActiveStorage::Blob.service.send(:path_for, @restoration.previous_report.key))
    end

    send_data output.to_pdf,
              filename: 'Combined Application.pdf',
              type: 'application/pdf',
              disposition: 'inline'
  end

  def view_estimate
    @restoration = model.find(params[:id])
    estimate = @restoration.estimates.find(params[:estimate])
    @portion = "#{estimate.contractor.name} estimate"
    @file = estimate.document
    render 'view_portion'
  end

  def view_legal_notice
    @restoration = model.find(params[:id])
    @portion = 'Legal Notice'
    @file = @restoration.legal_notice
    render 'view_portion'
  end

  def view_previous_report
    @restoration = model.find(params[:id])
    @portion = 'Previous Restoration Report'
    @file = @restoration.previous_report
    render 'view_portion'
  end

  def view_raw_application
    @restoration = model.find(params[:id])
    @portion = 'Raw Application'
    @file = @restoration.raw_application_file
    render 'view_portion'
  end

  def view_report
    @restoration = model.includes(estimates: :contractor).find(params[:id])

    pdf = generate_report
    send_data pdf.render,
              filename: "Report.pdf",
              type: 'application/pdf',
              disposition: 'inline'
  end

  private

  def application_create_params
    params.require(self.class::MODEL.name.downcase).permit(:amount, :cemetery_county, :raw_application_file)
  end

  def generate_report
    @report_class = self.class::PAGE_INFO[:report][:class]

    @report_class.new({
      writer: @restoration.investigator,
      cemetery: @restoration.cemetery,
      restoration: @restoration,
      report_date: @restoration.recommendation_date || Date.current
    })
  end

  def model
    self.class::MODEL
  end
end
