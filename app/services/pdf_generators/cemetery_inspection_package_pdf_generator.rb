module PDFGenerators
  class CemeteryInspectionPackagePDFGenerator < ApplicationService
    attr_reader :inspection

    def initialize(inspection)
      @inspection = inspection
    end

    def call
      output = CombinePDF.new

      # Add appropriate letter
      letter_params = {
        date: Date.current,
        recipient: @inspection.cemetery.name,
        address_line_one: @inspection.mailing_street_address,
        address_line_two: "#{@inspection.mailing_city}, #{@inspection.mailing_state} #{@inspection.mailing_zip}",
        cemetery: @inspection.cemetery,
        name: @inspection.investigator.name,
        title: @inspection.investigator.title,
        signature: @inspection.investigator.signature
      }

      if @inspection.violations?
        output << CombinePDF.parse(Letters::CemeteryInspectionViolationsPDF.new(letter_params).render)
      else
        output << CombinePDF.parse(Letters::CemeteryInspectionNoViolationsPDF.new(letter_params).render)
      end

      # Add inspection report
      output << CombinePDF.parse(BlankPDF.new({}).render)
      output << CombinePDF.parse(CemeteryInspectionReportPDFGenerator.call(@inspection).render)

      # Output violation items
      if @inspection.violations?
        output << CombinePDF.parse(CemeteryInspectionItemsPDF.new({ inspection: @inspection }).render)
        unless @inspection.sign?
          output << CombinePDF.load(Rails.root.join('app', 'pdfs', 'generated', "Sample Sign#{@inspection.cemetery.investigator_region == 1 ? ' NYC' : ''}.pdf"))
          output << CombinePDF.parse(BlankPDF.new({}).render)
        end
        output << CombinePDF.load(Rails.root.join('app', 'pdfs', 'generated', 'Sample Rules and Regulations.pdf')) unless @inspection.rules_approved?
      end

      # Output additional items
      CemeteryInspection::ADDITIONAL_DOCUMENTS.each do |document, title|
        if @inspection[:additional_documents][document.to_s]
          output << CombinePDF.load(Rails.root.join('app', 'pdfs', 'generated', "Sample #{title}.pdf"))
          output << CombinePDF.parse(BlankPDF.new({}).render) unless %i(by_laws rules).include? document
        end
      end

      output
    end
  end
end
