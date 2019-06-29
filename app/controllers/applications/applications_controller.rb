module Applications
  class ApplicationsController < ApplicationController
    def create
      @application = model.new(application_create_params)

      # Add new trustee if necessary
      trustee = Trustee.find_or_create_by(
          name: params[@application.to_sym][:trustee_name],
          cemetery_id: params[@application.to_sym][:cemetery])
      trustee.update(position: params[@application.to_sym][:trustee_position])

      @application.assign_attributes(
          cemetery_id: params[@application.to_sym][:cemetery],
          investigator_id: params[@application.to_sym][:investigator],
          trustee_name: trustee.name,
          trustee_position: trustee.position,
          submission_date: date_params([:submission_date], params[@application.to_sym])[:submission_date]
      )

      # If an application type exists, set it
      @application.application_type = params[:application_type] if @application.has_attribute? :application_type

      if @application.save
        self.class::CREATION_EVENT.new(@application, current_user).trigger
        redirect_to creation_success_path(@application)
      else
        @page_info = self.class::PAGE_INFO[:new]
        render :new
      end
    end

    private

    def application_create_params
      params.require(self.class::MODEL.name.downcase).permit(:amount, :cemetery_county, :raw_application_file)
    end

    def model
      self.class::MODEL
    end
  end
end