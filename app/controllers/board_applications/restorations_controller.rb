require 'net/http'

module BoardApplications
  class RestorationsController < BoardApplicationsController

    CREATION_EVENT = BoardApplications::BoardApplicationReceivedEvent
    
    def evaluate
      @restoration = model.includes(
          application_file_attachment: :blob,
          estimates: [:contractor, document_attachment: :blob],
          legal_notice_file_attachment: :blob
      ).find(params[:id])
      
      authorize [:board_applications, @restoration]
      @contractors = Contractor.all.order(:name)
      @remaining_letters = ('B'..'Z').to_a
    end

    def index
      if current_user.supervisor?
        @board_applications = model.includes(:cemetery, :status_changes).where(investigator: current_user).or(
            model.includes(:cemetery, :status_changes).evaluated)
      else
        @board_applications = model.includes(:cemetery, :status_changes).where(investigator: current_user)
      end
    end
    
    def make_schedulable
      @restoration = model.find(params[:id])
      @restoration.status = :reviewed
      @restoration.recommendation_date ||= Date.current
      @restoration.save
      BoardApplications::BoardApplicationReviewedEvent.new(@restoration, current_user).trigger
      
      redirect_to self.send("board_applications_#{@restoration.type.downcase}_path"), 
        flash: {
          success: 'You have successfully submitted this application.'
        }
    end

    def new
      @board_application = model.new(
        investigator: current_user,
        submission_date: Date.current
      )
      authorize [:board_applications, @board_application]
      @page_info = self.class::PAGE_INFO[:new]
    end

    def return_to_investigator
      @restoration = model.find(params[:id])
      @restoration.update(status: :assigned)
      BoardApplications::BoardApplicationReturnedEvent.new(@restoration, current_user).trigger
      
      redirect_to self.send("board_applications_#{@restoration.type.downcase}_path"),
        flash: {
          success: 'You have successfully returned this application to the assigned investigator.'
        }
    end

    def review
      @restoration = model.includes(estimates: :contractor).find(params[:id])
    end
    
    def send_to_supervisor
      @restoration = model.find(params[:id])

      @restoration.update(
        status: :evaluated,
        recommendation_date: Date.current
      )
      BoardApplications::BoardApplicationEvaluatedEvent.new(@restoration, current_user).trigger
      
      redirect_to self.send("board_applications_#{@restoration.type.downcase}_path"), 
        flash: {  
          success: 'You have successfully submitted this application.'
        }
    end

    def show
      @restoration = model.includes(estimates: :contractor).find(params[:id])
      authorize [:board_applications, @restoration]
      
      redirect_to self.send("evaluate_board_applications_#{@restoration.type.downcase}_path") if 
        @restoration.assigned? && @restoration.investigator == current_user
    end

    def upload_application
      upload_portion %i(application_file monuments application_form_complete field_visit_date)
    end

    def upload_legal_notice
      upload_portion %i(legal_notice_file legal_notice_newspaper legal_notice_cost legal_notice_format)
    end

    def upload_previous
      upload_portion %i(previous_completion_report_file previous_exists previous_type previous_date)
    end

    def view_application_form
      @restoration = model.find(params[:id])
      @portion = 'Application Form'
      @file = @restoration.application_file
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
      @file = @restoration.legal_notice_file
      render 'view_portion'
    end

    def view_previous_report
      @restoration = model.find(params[:id])
      @portion = 'Previous Restoration Report'
      @file = @restoration.previous_completion_report_file
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
