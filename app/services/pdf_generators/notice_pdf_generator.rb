module PDFGenerators
  class NoticePDFGenerator < ApplicationService
    attr_reader :notice

    def initialize(notice)
      @notice = notice
    end

    def call
      NoticePDF.new(
        @notice.attributes.merge(
          'cemetery_name' => @notice.cemetery.name,
          'cemetery_number' => @notice.cemetery.cemetery_id,
          'investigator_name' => @notice.investigator.name,
          'investigator_title' => @notice.investigator.title,
          'response_street_address' => @notice.investigator.street_address,
          'response_city' => @notice.investigator.city,
          'response_zip' => @notice.investigator.zip,
          'notice_date' => @notice.created_at,
          'secondary_law_sections' => @notice.law_sections,
          'served_on_title' => Trustee::POSITIONS[@notice.served_on_title.to_i]
        )
      )
    end
  end
end
