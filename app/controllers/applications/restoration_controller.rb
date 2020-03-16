require 'net/http'

module Applications
  class RestorationController < ApplicationsController

    CREATION_EVENT = Applications::ApplicationReceivedEvent

    def finish_processing
      @restoration = model.find(params[:id])

      if current_user.supervisor?
        @restoration.update(
          status: :reviewed,
          recommendation_date: Date.current,
          supervisor_review_date: Date.current
        )
        Applications::ApplicationReviewedEvent.new(@restoration, current_user).trigger
      else
        @restoration.update(
          status: :processed,
          recommendation_date: Date.current
        )
        Applications::ApplicationProcessedEvent.new(@restoration, current_user).trigger
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
      @application = model.new(investigator: current_user)
      authorize [:applications, @application]
      @page_info = self.class::PAGE_INFO[:new]
    end

    def process_restoration
      @restoration = model.includes(
          application_form_attachment: :blob,
          estimates: [:contractor, document_attachment: :blob],
          legal_notice_attachment: :blob)
        .find(params[:id])
      authorize [:applications, @restoration]
      @contractors = Contractor.all.order(:name)
    end

    def return_to_investigator
      @restoration = model.find(params[:id])
      @restoration.update(status: :received)
      Applications::ApplicationReturnedEvent.new(@restoration, current_user).trigger
    end

    def review
      @restoration = model.includes(estimates: :contractor).find(params[:id])
    end

    def send_to_board
      @restoration = model.find(params[:id])
      @restoration.update(status: :reviewed)
      @matter = Matter.create
      Applications::ApplicationReviewedEvent.new(@restoration, current_user).trigger
    end

    def show
      @restoration = model.includes(estimates: :contractor).find(params[:id])
      authorize [:applications, @restoration]

      redirect_to self.send("process_applications_#{@restoration.type.downcase}_path") if @restoration.received? && @restoration.investigator == current_user
    end

    def upload_application
      upload_portion %i(application_form monuments application_form_complete field_visit_date)
    end

    def upload_legal_notice
      upload_portion %i(legal_notice legal_notice_newspaper legal_notice_cost legal_notice_format)
    end

    def upload_previous
      upload_portion %i(previous_report previous_exists previous_type previous_date)
    end

    def view_application_form
      @restoration = model.find(params[:id])
      @portion = 'Application Form'
      @file = @restoration.application_form
      render 'view_portion'
    end

    def view_combined
      @restoration = model.find(params[:id])

      send_data PDFGenerators::RestorationCombinedPDFGenerator.call(@restoration, self.class::PAGE_INFO[:report][:class]).to_pdf,
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

      send_data PDFGenerators::RestorationReportPDFGenerator.call(@restoration, self.class::PAGE_INFO[:report][:class]).render,
                filename: 'Report.pdf',
                type: 'application/pdf',
                disposition: 'inline'
    end

    private

    def upload_portion(keys)
      @restoration = model.find(params[:id])
      @restoration.update(keys.map { |key| [key, params[@restoration.to_sym][key]] }.to_h)
    end
  end
end
