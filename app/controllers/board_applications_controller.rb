class BoardApplicationsController < ApplicationController
  def create
    @board_application = model.new(board_application_create_params)

    @board_application.assign_attributes(
      cemetery_cemid: params[@board_application.to_sym][:cemetery],
      investigator_id: params[@board_application.to_sym][:investigator],
      trustee_id: params[@board_application.to_sym][:trustee]
    )

    # If an application type exists, set it
    @board_application.application_type = params[:application_type] if @board_application.has_attribute? :application_type
    
    # Set as assigned if an investigator is set
    @board_application.status = :assigned if @board_application.investigator

    if @board_application.valid? && verify_upload(params[self.class::MODEL.name.downcase][:raw_application_file])
      @board_application.save
      self.class::CREATION_EVENT.new(@board_application, current_user).trigger
      redirect_to creation_success_path(@board_application)
    else
      @page_info = self.class::PAGE_INFO[:new]
      render :new
    end
  end

  private

  def board_application_create_params
    params.require(self.class::MODEL.name.downcase).permit(:amount, :cemetery_county, :raw_application_file, :submission_date)
  end

  def model
    self.class::MODEL
  end
  
  def verify_upload(document)
    @board_application.errors.add(:raw_application_file, :blank) and return false unless document.present?
    @board_application.errors.add(:raw_application_file, :invalid) and return false unless document.content_type == 'application/pdf'
    true
  end
end
