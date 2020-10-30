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
          'cemetery_number' => @notice.cemetery.formatted_cemid,
          'investigator_name' => @notice.investigator.name,
          'investigator_title' => @notice.investigator.title,
          'trustee_name' => @notice.trustee.name,
          'trustee_position' => @notice.trustee.position_name,
          'response_street_address' => @notice.investigator.street_address,
          'response_city' => @notice.investigator.city,
          'response_zip' => @notice.investigator.zip,
          'notice_date' => @notice.created_at
        )
      )
    end
  end
end
