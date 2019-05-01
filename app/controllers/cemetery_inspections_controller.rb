class CemeteryInspectionsController < ApplicationController
  def cemetery_information
    @inspection = CemeteryInspection.find_by_identifier(params[:cemetery_inspection][:identifier])
    @inspection.update(cemetery_information_params)

    # Add trustee if he/she doesn't exist
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

  def create_old_inspection
    @cemetery = Cemetery.find(params[:id])
    @inspection = CemeteryInspection.new(cemetery_inspection_date_params)

    investigator = params[:cemetery_inspection][:investigator].present? ? User.find(params[:cemetery_inspection][:investigator]) : nil
    @inspection.assign_attributes(
      cemetery: @cemetery,
      investigator: investigator,
      status: CemeteryInspection::STATUSES[:complete]
    )

    if @inspection.valid? && verify_upload(params[:cemetery_inspection][:inspection_report])
      @inspection.save
      @inspection.inspection_report.attach(params[:cemetery_inspection][:inspection_report])

      # Only update the inspection date if it's newer than the last
      @cemetery.update(last_inspection_date: @inspection.date_performed) if @inspection.date_performed > @cemetery.last_inspection_date

      redirect_to show_inspection_cemetery_path(uuid: @inspection)
    else
      render :upload_old_inspection
    end
  end

  def incomplete
    @incomplete = current_user.incomplete_inspections
  end

  def perform
    @cemetery = Cemetery.find(params[:id])
    @inspection = CemeteryInspection.where(cemetery: @cemetery, status: CemeteryInspection::STATUSES[:begun]).first ||
        CemeteryInspection.new(
          cemetery: @cemetery,
          investigator: current_user,
          date_performed: Date.current,
          trustee_state: 'NY')
    #@inspection.save
  end

  def physical_characteristics
    @inspection = CemeteryInspection.find_by_identifier(params[:cemetery_inspection][:identifier])
    @inspection.update(physical_characteristics_params)
  end

  def show
    @cemetery = Cemetery.find(params[:id])
    @inspection = CemeteryInspection.find_by_identifier(params[:identifier])
  end

  def upload_old_inspection
    @cemetery = Cemetery.find(params[:id])
    @inspection = CemeteryInspection.new
  end

  def view_report
    @cemetery = Cemetery.find(params[:id])
    @inspection = CemeteryInspection.find_by_identifier(params[:identifier])

    pdf = CemeteryInspectionReportPDF.new({ inspection: @inspection })
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

  def verify_upload(document)
    @inspection.errors.add(:inspection_report, :blank) and return false unless document.present?
    true
  end
end
