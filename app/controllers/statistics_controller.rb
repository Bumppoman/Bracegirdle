class StatisticsController < ApplicationController
  def investigator_report
    date = Date.current
    send_data InvestigatorStatisticsReportPdf.new(
      {
        investigator: current_user,
        month: date.month,
        year: date.year,
        month_name: date.strftime('%B')
      }).render,
      filename: "Investigator Statistics.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end
end
