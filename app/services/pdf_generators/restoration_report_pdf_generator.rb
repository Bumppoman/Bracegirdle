module PDFGenerators
  class RestorationReportPDFGenerator < ApplicationService
    attr_reader :restoration

    def initialize(restoration, pdf_class)
      @restoration = restoration
      @pdf_class = pdf_class
    end

    def call
      @pdf_class.new(
        {
          writer: @restoration.investigator,
          cemetery: @restoration.cemetery,
          restoration: @restoration,
          report_date: @restoration.recommendation_date || Date.current
        }
      )
    end
  end
end
