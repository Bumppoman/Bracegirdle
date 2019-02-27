class Reports::HazardousReportPDF < Reports::ReportPDF
  def initialize(*args)
    @regarding = 'Application for Repair of Hazardous Monuments'
    super
  end

  def report_body
  end

  protected

  def build_exhibits
    exhibits = [
      ['Application for Repair or Removal of Dilapidated or Disrepaired Monuments that Create a Hazardous Condition', nil]
    ]

    @params[:estimates].each do |estimate|
      exhibits << [estimate, nil]
    end

    exhibits
  end
end