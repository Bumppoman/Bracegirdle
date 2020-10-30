class CemeteryInspectionsController < ApplicationController
  def begin
    @cemetery = Cemetery.find(params[:cemid])

    BeginCemeteryInspection.new(@cemetery, current_user).call
    
    redirect_to inspect_cemetery_path(@cemetery)
  end
  
  def complete
    @inspection = authorize CemeteryInspection.find_by_identifier(params[:identifier])
    @inspection.update(status: :performed)
    
    CemeteryInspections::CemeteryInspectionStatusChangedEvent.new(@inspection, current_user).trigger
    
    redirect_to show_inspection_cemetery_path(@inspection.cemetery, @inspection)
  end
  
  def create
    @cemetery = Cemetery.find(params[:cemid])
    @inspection = authorize CemeteryInspection.new

    investigator = 
      params[:cemetery_inspection][:investigator].present? ?
        User.find(params[:cemetery_inspection][:investigator]) :
        nil
        
    @inspection.assign_attributes(
      cemetery: @cemetery,
      investigator: investigator,
      date_performed: params[:cemetery_inspection][:date_performed],
      status: :completed
    )

    if @inspection.valid? && verify_upload(params[:cemetery_inspection][:inspection_report])
      @inspection.save
      @inspection.inspection_report.attach(params[:cemetery_inspection][:inspection_report])
      
      CemeteryInspections::CemeteryInspectionUploadedEvent.new(@inspection, current_user).trigger

      # Only update the inspection date if it's newer than the last
      @cemetery.update(last_inspection_date: @inspection.date_performed) if
        @cemetery.last_inspection_date && @inspection.date_performed > @cemetery.last_inspection_date

      redirect_to show_inspection_cemetery_path(identifier: @inspection)
    else
      render :upload
    end
  end

  def finalize
    @inspection = authorize CemeteryInspection.find_by_identifier(params[:identifier])
    @inspection.update(
      status: :completed,
      date_mailed: Date.current
    )
    @inspection.cemetery.update(last_inspection_date: @inspection.date_performed)
    CemeteryInspections::CemeteryInspectionCompletedEvent.new(@inspection, current_user).trigger
    
    respond_to :js
  end

  def incomplete
    @incomplete = authorize current_user.incomplete_inspections
  end

  def perform
    @cemetery = Cemetery.find(params[:cemid])
    @inspection = authorize CemeteryInspection.where(cemetery: @cemetery).where.not(status: [:performed, :completed]).first
  end

  def revise
    @inspection = authorize CemeteryInspection.find_by_identifier(params[:identifier])
    @inspection.update(status: :begun)
    
    CemeteryInspections::CemeteryInspectionStatusChangedEvent.new(@inspection, current_user).trigger
    
    redirect_to inspect_cemetery_path(@inspection.cemetery)
  end
  
  def save
    @inspection = authorize CemeteryInspection.find_by_identifier(params[:identifier])
    @inspection.update(cemetery_inspection_params)

    if @inspection.previous_changes.include?(:status)
      CemeteryInspections::CemeteryInspectionStatusChangedEvent.new(@inspection, current_user).trigger
    end
  end

  def show
    @cemetery = Cemetery.find(params[:cemid])
    @inspection = authorize CemeteryInspection.find_by_identifier(params[:identifier])
  end

  def upload
    @cemetery = Cemetery.find(params[:cemid])
    @inspection = authorize CemeteryInspection.new
  end

  def view_full_package
    @inspection = authorize CemeteryInspection.find_by_identifier(params[:identifier])

    send_data PDFGenerators::CemeteryInspectionPackagePDFGenerator.call(@inspection).to_pdf,
      filename: "Inspection Package #{@inspection.identifier}.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end

  def view_report
    @cemetery = Cemetery.find(params[:cemid])
    @inspection = authorize CemeteryInspection.find_by_identifier(params[:identifier])

    send_data PDFGenerators::CemeteryInspectionReportPDFGenerator.call(@inspection).render,
      filename: "Inspection #{params[:identifier]}.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end

  private
  
  def cemetery_inspection_params
    params.require(:cemetery_inspection).permit(
      [
        :additional_comments, :annual_meetings, :annual_meetings_comments, 
        :body_delivery_receipt, :body_delivery_receipt_comments, :burial_permits, :burial_permits_comments, 
        :burial_records, :burial_records_comments, :cemetery_email, :cemetery_location, 
        :cemetery_phone, :cemetery_sign_text, :community_mausoleum, :community_mausoleum_comments, 
        :deeds_signed, :deeds_signed_comments, :directional_signs_comments, :directional_signs_present, 
        :directional_signs_required, :election, :employees, :employees_comments, :fencing, :fencing_comments,
        :grave_liners, :grave_liners_comments, :lawn_crypts, :lawn_crypts_comments,
        :mailing_city, :mailing_state, :mailing_street_address, :mailing_zip,
        :main_road, :new_memorials, :number_of_trustees, :offices, 
        :offices_comments, :old_memorials, :overall_conditions, :pet_burials, :pet_burials_comments, 
        :prices_displayed, :prices_displayed_comments, :private_mausoleum, :private_mausoleum_comments, 
        :receiving_vault_bodies, :receiving_vault_clean, :receiving_vault_exclusive, :receiving_vault_exists, 
        :receiving_vault_inspected, :receiving_vault_obscured, :receiving_vault_secured, :renovations, 
        :rules_approved, :rules_approved_comments, :rules_displayed, :rules_displayed_comments, 
        :rules_provided, :rules_provided_comments, :sale_of_monuments, :sale_of_monuments_comments,
        :scattering_gardens, :scattering_gardens_comments, :side_roads, :sign, 
        :sign_comments, :status, :trustee_id, :trustees_compensated, :trustees_compensated_comments,
        :vandalism, :winter_burials, :winter_burials_comments, additional_documents: {}
      ]
    )
  end

  def verify_upload(document)
    @inspection.errors.add(:inspection_report, :blank) and return false unless document.present?
    true
  end
end
