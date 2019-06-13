class StatisticsController < ApplicationController
  def investigator_report
    send_data InvestigatorStatisticsReportPdf.new({ investigator: current_user }).render,
      filename: "Investigator Statistics.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end
end
