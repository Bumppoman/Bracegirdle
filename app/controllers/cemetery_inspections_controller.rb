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

      # Only update the inspection date if it's newer than the last
      @cemetery.update(last_inspection_date: @inspection.date_performed) if @inspection.date_performed > @cemetery.last_inspection_date

      redirect_to show_inspection_cemetery_path(date: @inspection)
    else
      render :upload_old_inspection
    end
  end

  def show
    @cemetery = Cemetery.find(params[:id])
    @inspection = CemeteryInspection.where(cemetery: @cemetery, date_performed: Date.strptime(params[:date])).first
  end

  def upload_old_inspection
    @cemetery = Cemetery.find(params[:id])
    @inspection = CemeteryInspection.new
  end

  def view_report
    @cemetery = Cemetery.find(params[:id])
    @inspection = CemeteryInspection.find_by(cemetery: @cemetery, date_performed: Date.strptime(params[:date]))

    pdf = CemeteryInspectionReportPDF.new({})
    send_data pdf.render,
              filename: "Inspection #{params[:date]}.pdf",
              type: 'application/pdf',
              disposition: 'inline'
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
