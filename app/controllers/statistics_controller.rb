class StatisticsController < ApplicationController
  def investigator_report
    send_data InvestigatorStatisticsReportPdf.new(
      {
        investigator: current_user,
        month: 5,
        year: 2019,
        month_name: 'May'
      }).render,
      filename: "Investigator Statistics.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end
end
