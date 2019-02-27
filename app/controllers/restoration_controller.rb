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
      application_type: params[:type])

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
    @restoration = Restoration.find(params[:id])
  end

  def view_raw_application
    @restoration = Restoration.find(params[:id])
    @portion = 'Raw Application'
    @file = @restoration.raw_application_file
    render 'view_portion'
  end

  # TODO:  fix report date
  # TODO:  fix exhibits
  def view_report
    @restoration = Restoration.find(params[:id])
    @report_class = PAGE_INFO[@restoration.application_type][:report][:class]

    pdf = @report_class.new({
      writer_name: current_user.name,
      writer_title: current_user.title,
      cemetery_name: @restoration.cemetery.name,
      cemetery_number: @restoration.cemetery.cemetery_id,
      report_date: Date.current,
      estimates: [
          'McFee Memorials estimate for $26,926.00',
          'Humphrey Memorials estimate for $31,380.00'
      ]
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
    params.require(:restoration).permit(:amount, :cemetery_county, :submission_date, :raw_application_file)
  end

  def hazardous
    @applications = Restoration.hazardous
  end

  def vandalism
    @applications = Restoration.vandalism
  end
end
