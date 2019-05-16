require 'net/http'

class RestorationController < ApplicationController
  include Permissions

  before_action do
    stipulate :must_be_investigator
  end

  PAGE_INFO = {
    abandonment: {
      new: {
        title: 'Upload New Abandonment Application',
        breadcrumbs: 'Abandonment applications'
      }
    },
    hazardous: {
      new: {
        title: 'Upload New Hazardous Monuments Application',
        breadcrumbs: 'Hazardous monuments applications'
      },
      report: {
        class: Reports::HazardousReportPdf,
      }
    },
    vandalism: {
      new: {
        title: 'Upload New Vandalism Application',
        breadcrumbs: 'Vandalism applications'
      }
    }
  }.freeze

  def create
    # Add new trustee if necessary
    trustee = Trustee.find_or_create_by(
        name: params[:restoration][:trustee_name],
        cemetery_id: params[:restoration][:cemetery])
    trustee.update(position: params[:restoration][:trustee_position])

    @restoration = Restoration.new(application_create_params)
    @restoration.assign_attributes(
      cemetery_id: params[:restoration][:cemetery],
      investigator_id: params[:restoration][:investigator],
      trustee_name: trustee.name,
      trustee_position: trustee.position,
      application_type: params[:type],
      submission_date: date_params([:submission_date], params[:restoration])[:submission_date]
    )

    if @restoration.save
      Restoration::RestorationReceivedEvent.new(@restoration, current_user).trigger
      redirect_to restoration_path(@restoration, type: params[:type])
    else
      render :new
    end
  end

  def finish_processing
    @restoration = Restoration.find(params[:id])

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
    self.send(params[:type])
    render params[:type]
  end

  def new
    @type = params[:type].to_sym
    @restoration = Restoration.new(application_type: @type)
    @page_info = PAGE_INFO[@type][:new]
  end

  def process_restoration
    @restoration = Restoration.includes(
        application_form_attachment: :blob,
        estimates: [:contractor, document_attachment: :blob],
        legal_notice_attachment: :blob)
      .find(params[:id])
    @contractors = Contractor.all.order(:name)
  end

  def review
    @restoration = Restoration.includes(estimates: :contractor).find(params[:id])
  end

  def show
    @restoration = Restoration.includes(estimates: :contractor).find(params[:id])

    redirect_to :process_restoration if @restoration.unprocessed? && @restoration.investigator == current_user
  end

  def upload_application
    @restoration = Restoration.find(params[:id])
    @restoration.update(
      application_form: params[:restoration][:application_form],
      monuments: params[:restoration][:monuments],
      application_form_complete: params[:restoration][:application_form_complete],
      field_visit_date: date_params([:field_visit_date], params[:restoration])[:field_visit_date]
    )
  end

  def upload_legal_notice
    @restoration = Restoration.find(params[:id])
    @restoration.update(
      legal_notice: params[:restoration][:legal_notice],
      legal_notice_newspaper: params[:restoration][:legal_notice_newspaper],
      legal_notice_cost: params[:restoration][:legal_notice_cost],
      legal_notice_format: params[:restoration][:legal_notice_format]
    )
  end

  def upload_previous
    @restoration = Restoration.find(params[:id])
    @restoration.update(
      previous_report: params[:restoration][:previous_report],
      previous_exists: params[:restoration][:previous_exists],
      previous_type: params[:restoration][:previous_type],
      previous_date: params[:restoration][:previous_date]
    )
  end

  def view_application_form
    @restoration = Restoration.find(params[:id])
    @portion = 'Application Form'
    @file = @restoration.application_form
    render 'view_portion'
  end

  def view_combined
    @restoration = Restoration.find(params[:id])
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
    output << CombinePDF.parse(ExhibitSheetPDF.new({ exhibit: exhibit_letters[current]}).render)
    output << CombinePDF.load(ActiveStorage::Blob.service.send(:path_for, @restoration.legal_notice.key))

    # Include previous report if applicable
    if @restoration.previous_exists?
      current += 1
      output << CombinePDF.parse(ExhibitSheetPDF.new({ exhibit: exhibit_letters[current]}).render)
      output << CombinePDF.load(ActiveStorage::Blob.service.send(:path_for, @restoration.previous_report.key))
    end

    send_data output.to_pdf,
              filename: 'Combined Application.pdf',
              type: 'application/pdf',
              disposition: 'inline'
  end

  def view_estimate
    @restoration = Restoration.find(params[:id])
    estimate = @restoration.estimates.find(params[:estimate])
    @portion = "#{estimate.contractor.name} estimate"
    @file = estimate.document
    render 'view_portion'
  end

  def view_legal_notice
    @restoration = Restoration.find(params[:id])
    @portion = 'Legal Notice'
    @file = @restoration.legal_notice
    render 'view_portion'
  end

  def view_raw_application
    @restoration = Restoration.find(params[:id])
    @portion = 'Raw Application'
    @file = @restoration.raw_application_file
    render 'view_portion'
  end

  def view_report
    @restoration = Restoration.includes(estimates: :contractor).find(params[:id])

    pdf = generate_report
    send_data pdf.render,
              filename: "Report.pdf",
              type: 'application/pdf',
              disposition: 'inline'
  end

  private

  def abandonment
    @applications = Restoration.includes(:cemetery).abandonment.where(investigator: current_user)
  end

  def application_create_params
    params.require(:restoration).permit(:amount, :cemetery_county, :raw_application_file)
  end

  def generate_report
    @report_class = PAGE_INFO[@restoration.application_type][:report][:class]

    @report_class.new({
      writer: @restoration.investigator,
      cemetery: @restoration.cemetery,
      restoration: @restoration,
      report_date: @restoration.recommendation_date || Date.current
    })
  end

  def hazardous
    @applications = Restoration.includes(:cemetery).hazardous.where(investigator: current_user)
  end

  def vandalism
    @applications = Restoration.includes(:cemetery).vandalism.where(investigator: current_user)
  end
end
