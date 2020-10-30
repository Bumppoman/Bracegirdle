module PDFGenerators
  class RestorationCombinedPDFGenerator < ApplicationService
    attr_reader :restoration

    def initialize(restoration, pdf_class)
      @restoration = restoration
      @pdf_class = pdf_class
    end

    def call
      output = CombinePDF.new
      output << CombinePDF.parse(RestorationReportPDFGenerator.call(@restoration, @pdf_class).render)

      # Include application
      output << CombinePDF.parse(ExhibitSheetPDF.new({ exhibit: 'A' }).render)
      output << CombinePDF.load(ActiveStorage::Blob.service.send(:path_for, @restoration.application_file.key))

      # Include estimates
      exhibit_letters = ('B'..'Z').to_a
      exhibits = @restoration.estimates.length
      current = 0
      while current < exhibits
        output << CombinePDF.parse(ExhibitSheetPDF.new({ exhibit: exhibit_letters[current]}).render)
        output << CombinePDF.load(ActiveStorage::Blob.service.send(:path_for, @restoration.estimates[current].document.key))
        current += 1
      end

      # Include legal notice
      output << CombinePDF.parse(ExhibitSheetPDF.new({ exhibit: exhibit_letters[current]}).render)
      output << CombinePDF.load(ActiveStorage::Blob.service.send(:path_for, @restoration.legal_notice_file.key))

      # Include previous report if applicable
      if @restoration.previous_exists?
        current += 1
        output << CombinePDF.parse(ExhibitSheetPDF.new({ exhibit: exhibit_letters[current]}).render)
        output << CombinePDF.load(ActiveStorage::Blob.service.send(
          :path_for, @restoration.previous_completion_report_file.key)
        )
      end

      output
    end
  end
end
