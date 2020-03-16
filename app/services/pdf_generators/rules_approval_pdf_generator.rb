module PDFGenerators
  class RulesApprovalPDFGenerator < ApplicationService
    def initialize(rules)
      @rules = rules
    end

    def call
      if @rules.request_by_email
        address_line_one = @rules.sender_email
        address_line_two = ''
      else
        address_line_one = @rules.sender_street_address
        address_line_two = "#{@rules.sender_city}, #{@rules.sender_state} #{@rules.sender_zip}"
      end

      Letters::RulesApprovalPDF.new({
        approval_date: @rules.approval_date.to_s,
        cemetery_name: @rules.cemetery.name,
        address_line_one: address_line_one,
        address_line_two: address_line_two,
        cemetery_number: @rules.cemetery.cemetery_id,
        submission_date: @rules.submission_date.to_s,
        name: @rules.investigator.name,
        title: @rules.investigator.title,
        signature: @rules.investigator.signature
      }, date: :approval_date, recipient: :cemetery_name)
    end
  end
end
