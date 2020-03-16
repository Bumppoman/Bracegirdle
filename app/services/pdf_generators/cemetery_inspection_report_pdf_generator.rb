module PDFGenerators
  class CemeteryInspectionReportPDFGenerator < ApplicationService
    attr_reader :inspection

    def initialize(inspection)
      @inspection = inspection
    end

    def call
      CemeteryInspectionReportPDF.new(
        {
          inspection: @inspection,
          signature: @inspection.investigator.signature
        })
    end
  end
end
