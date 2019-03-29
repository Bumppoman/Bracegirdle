class CemeteryInspectionsController < ApplicationController
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
      @cemetery.update(last_inspection_date: @inspection.date_performed)
      redirect_to @inspection
    else
      render :upload_old_inspection
    end
  end

  def upload_old_inspection
    @cemetery = Cemetery.find(params[:id])
    @inspection = CemeteryInspection.new
  end

  private

  def cemetery_inspection_date_params
    date_params %w(date_performed), params[:cemetery_inspection]
  end

  def verify_upload(document)
    @inspection.errors.add(:inspection_report, :blank) and return false unless document.present?
    true
  end
end
