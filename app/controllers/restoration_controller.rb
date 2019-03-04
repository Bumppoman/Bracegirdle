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
        class: Reports::HazardousReportPDF,
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
    @restoration = Restoration.new(application_create_params)
    @restoration.assign_attributes(
      cemetery_id: params[:restoration][:cemetery],
      user_id: params[:restoration][:investigator],
      trustee_id: params[:restoration][:trustee],
      application_type: params[:type],
      submission_date: date_params(:submission_date, params)[:submission_date])

    if @restoration.save
      Restoration::RestorationReceivedEvent.new(@restoration, current_user).trigger
      redirect_to restoration_path(@restoration, type: params[:type])
    else
      render :new
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

  def show
    @restoration = Restoration.includes(
        application_form_attachment: :blob,
        estimates: [:contractor, document_attachment: :blob],
        legal_notice_attachment: :blob)
      .find(params[:id])
    @contractors = Contractor.all.order(:name)
  end

  def upload_application
    @restoration = Restoration.find(params[:id])
    @restoration.update(
      application_form: params[:restoration][:application_form],
      monuments: params[:restoration][:monuments],
      application_form_complete: params[:restoration][:application_form_complete]
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

  def view_application_form
    @restoration = Restoration.find(params[:id])
    @portion = 'Application Form'
    @file = @restoration.application_form
    render 'view_portion'
  end

  def view_raw_application
    @restoration = Restoration.find(params[:id])
    @portion = 'Raw Application'
    @file = @restoration.raw_application_file
    render 'view_portion'
  end

  # TODO:  fix report date
  def view_report
    @restoration = Restoration.find(params[:id])
    @report_class = PAGE_INFO[@restoration.application_type][:report][:class]

    pdf = @report_class.new({
      writer: @restoration.investigator,
      cemetery: @restoration.cemetery,
      restoration: @restoration,
      report_date: Date.current,
      verification_date: Date.current,
      previous: {
          type: 'hazardous monuments',
          date: 'September 2017'
      }
    })

    send_data pdf.render,
              filename: "Report.pdf",
              type: 'application/pdf',
              disposition: 'inline'
  end

  private

  def abandonment
    @applications = Restoration.abandonment
  end

  def application_create_params
    params.require(:restoration).permit(:amount, :cemetery_county, :raw_application_file)
  end

  def hazardous
    @applications = Restoration.hazardous
  end

  def vandalism
    @applications = Restoration.vandalism
  end
end
