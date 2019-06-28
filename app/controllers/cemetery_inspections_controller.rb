class CemeteryInspectionsController < ApplicationController
  include Permissions

  before_action do
    stipulate :must_be_investigator
  end

  def additional_information
    @inspection = CemeteryInspection.find_by_identifier(params[:cemetery_inspection][:identifier])
    @inspection.update(
      additional_comments: params[:cemetery_inspection][:additional_comments],
      status: :performed)
  end

  def cemetery_information
    @inspection = CemeteryInspection.find_by_identifier(params[:cemetery_inspection][:identifier])
    @inspection.date_performed = cemetery_inspection_date_params['date_performed']
    @inspection.update(cemetery_information_params)

    # Add trustee if he/she doesn't exist
    if params[:cemetery_inspection][:trustee_name].present?
      Trustee.find_or_create_by(cemetery: @inspection.cemetery, name: params[:cemetery_inspection][:trustee_name]).update(
        position: params[:cemetery_inspection][:trustee_position],
        street_address: params[:cemetery_inspection][:trustee_street_address],
        city: params[:cemetery_inspection][:trustee_city],
        state: params[:cemetery_inspection][:trustee_state],
        zip: params[:cemetery_inspection][:trustee_zip],
        phone: params[:cemetery_inspection][:trustee_phone],
        email: params[:cemetery_inspection][:trustee_email]
      )
    end
  end

  def create_old_inspection
    @cemetery = Cemetery.find_by_cemetery_id(params[:cemetery_id])
    @inspection = CemeteryInspection.new(cemetery_inspection_date_params)

    investigator = params[:cemetery_inspection][:investigator].present? ? User.find(params[:cemetery_inspection][:investigator]) : nil
    @inspection.assign_attributes(
      cemetery: @cemetery,
      investigator: investigator,
      status: :complete
    )

    if @inspection.valid? && verify_upload(params[:cemetery_inspection][:inspection_report])
      @inspection.save
      @inspection.inspection_report.attach(params[:cemetery_inspection][:inspection_report])

      # Only update the inspection date if it's newer than the last
      @cemetery.update(last_inspection_date: @inspection.date_performed) if
        @cemetery.last_inspection_date && @inspection.date_performed > @cemetery.last_inspection_date

      redirect_to show_inspection_cemetery_path(identifier: @inspection)
    else
      render :upload_old_inspection
    end
  end

  def finalize
    @inspection = CemeteryInspection.find_by_identifier(params[:identifier])
    @inspection.update(
      status: :complete,
      date_mailed: Date.current
    )
    @inspection.cemetery.update(last_inspection_date: @inspection.date_performed)
    CemeteryInspections::CemeteryInspectionCompletedEvent.new(@inspection, current_user).trigger
  end

  def incomplete
    @incomplete = current_user.incomplete_inspections
  end

  def perform
    @cemetery = Cemetery.find_by_cemetery_id(params[:cemetery_id])
    @inspection = CemeteryInspection.where(cemetery: @cemetery, status: :begun).first ||
      CemeteryInspection.new(
        cemetery: @cemetery,
        investigator: current_user,
        date_performed: Date.current,
        trustee_state: 'NY',
        status: :begun)
    @inspection.save
  end

  def physical_characteristics
    @inspection = CemeteryInspection.find_by_identifier(params[:cemetery_inspection][:identifier])
    @inspection.update(physical_characteristics_params)
  end

  def record_keeping
    @inspection = CemeteryInspection.find_by_identifier(params[:cemetery_inspection][:identifier])
    @inspection.update(record_keeping_params)
  end

  def revise
    @inspection = CemeteryInspection.find_by_identifier(params[:identifier])
    @inspection.update(status: :begun)
  end

  def show
    @cemetery = Cemetery.find_by_cemetery_id(params[:cemetery_id])
    @inspection = CemeteryInspection.find_by_identifier(params[:identifier])
  end

  def upload_old_inspection
    @cemetery = Cemetery.find_by_cemetery_id(params[:cemetery_id])
    @inspection = CemeteryInspection.new
  end

  def view_full_package
    @inspection = CemeteryInspection.find_by_identifier(params[:identifier])
    output = CombinePDF.new

    # Add appropriate letter
    letter_params = {
      date: Date.current,
      recipient: @inspection.cemetery.name,
      address_line_one: @inspection.trustee_street_address,
      address_line_two: "#{@inspection.trustee_city}, #{@inspection.trustee_state} #{@inspection.trustee_zip}",
      cemetery: @inspection.cemetery,
      name: @inspection.investigator.name,
      title: @inspection.investigator.title,
      signature: @inspection.investigator.signature
    }

    if @inspection.violations?
      output << CombinePDF.parse(Letters::CemeteryInspectionViolationsPdf.new(letter_params).render)
    else
      output << CombinePDF.parse(Letters::CemeteryInspectionNoViolationsPdf.new(letter_params).render)
    end

    # Add inspection report
    output << CombinePDF.parse(BlankPdf.new({}).render)
    output << CombinePDF.parse(generate_report.render)

    # Output violation items
    if @inspection.violations?
      output << CombinePDF.parse(CemeteryInspectionItemsPdf.new({ inspection: @inspection }).render)
      unless @inspection.sign?
        output << CombinePDF.load(Rails.root.join('app', 'pdfs', 'generated', "Sample Sign#{@inspection.cemetery.investigator_region == 1 ? ' NYC' : ''}.pdf"))
        output << CombinePDF.parse(BlankPdf.new({}).render)
      end
      output << CombinePDF.load(Rails.root.join('app', 'pdfs', 'generated', 'Sample Rules and Regulations.pdf')) unless @inspection.rules_approved?
    end


    # Output package
    send_data output.to_pdf,
      filename: "Inspection Package #{@inspection.identifier}.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end

  def view_report
    @cemetery = Cemetery.find_by_cemetery_id(params[:cemetery_id])
    @inspection = CemeteryInspection.find_by_identifier(params[:identifier])

    pdf = generate_report
    send_data pdf.render,
      filename: "Inspection #{params[:identifier]}.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end

  private

  def cemetery_information_params
    params.require(:cemetery_inspection).permit(
      :trustee_name, :trustee_position, :trustee_street_address,
      :trustee_city, :trustee_state, :trustee_zip, :trustee_phone,
      :trustee_email, :cemetery_location, :cemetery_sign_text)
  end

  def cemetery_inspection_date_params
    date_params %w(date_performed), params[:cemetery_inspection]
  end

  def generate_report
    CemeteryInspectionReportPdf.new(
      {
          inspection: @inspection,
          signature: @inspection.investigator.signature
      })
  end

  def physical_characteristics_params
    params.require(:cemetery_inspection).permit(
      :sign, :sign_comments, :offices, :offices_comments,
      :rules_displayed, :rules_displayed_comments, :prices_displayed, :prices_displayed_comments,
      :scattering_gardens, :scattering_gardens_comments, :community_mausoleum, :community_mausoleum_comments,
      :private_mausoleum, :private_mausoleum_comments, :lawn_crypts, :lawn_crypts_comments,
      :grave_liners, :grave_liners_comments, :sale_of_monuments, :sale_of_monuments_comments,
      :fencing, :fencing_comments, :winter_burials, :winter_burials_comments, :main_road,
      :side_roads, :new_memorials, :old_memorials, :vandalism, :hazardous_materials,
      :receiving_vault_exists, :receiving_vault_inspected, :receiving_vault_bodies, :receiving_vault_clean,
      :receiving_vault_obscured, :receiving_vault_exclusive, :receiving_vault_secured, :overall_conditions, :renovations
    )
  end

  def record_keeping_params
    params.require(:cemetery_inspection).permit(
      :annual_meetings, :annual_meetings_comments, :election, :number_of_trustees,
      :burial_permits, :burial_permits_comments, :body_delivery_receipt, :body_delivery_receipt_comments,
      :deeds_signed, :deeds_signed_comments, :burial_records, :burial_records_comments,
      :rules_provided, :rules_provided_comments, :rules_approved, :rules_approved_comments,
      :employees, :employees_comments, :trustees_compensated, :trustees_compensated_comments,
      :pet_burials, :pet_burials_comments
    )
  end

  def verify_upload(document)
    @inspection.errors.add(:inspection_report, :blank) and return false unless document.present?
    true
  end
end