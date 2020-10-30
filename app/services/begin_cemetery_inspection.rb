class BeginCemeteryInspection < ApplicationService
  def initialize(cemetery, current_user)
    @cemetery = cemetery
    @current_user = current_user
  end
  
  def call
    if CemeteryInspection.where(cemetery: @cemetery).where.not(status: [:performed, :completed]).count > 0
      false
    else
      @inspection = CemeteryInspection.create(
        cemetery: @cemetery,
        investigator: @current_user,
        date_performed: Date.current,
        mailing_state: 'NY',
        status: :begun
      )
      
      CemeteryInspections::CemeteryInspectionBegunEvent.new(@inspection, @current_user).trigger
      
      true
    end
  end
end