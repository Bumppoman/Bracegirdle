module PDFGenerators
  class RulesApprovalPDFGenerator < ApplicationService
    def initialize(rules_approval)
      @rules_approval = rules_approval
    end

    def call
      if @rules_approval.request_by_email
        address_line_one = @rules_approval.sender_email
        address_line_two = ''
      else
        address_line_one = @rules_approval.sender_street_address
        address_line_two = "#{@rules_approval.sender_city}, #{@rules_approval.sender_state} #{@rules_approval.sender_zip}"
      end

      Letters::RulesApprovalPDF.new(
        {
          approval_date: @rules_approval.approval_date.to_s,
          cemetery_name: @rules_approval.cemetery.name,
          address_line_one: address_line_one,
          address_line_two: address_line_two,
          cemetery_number: @rules_approval.cemetery.formatted_cemid,
          submission_date: @rules_approval.submission_date.to_s,
          name: @rules_approval.investigator.name,
          title: @rules_approval.investigator.title,
          signature: @rules_approval.investigator.signature
        }, 
        date: :approval_date, 
        recipient: :cemetery_name
      )
    end
  end
end
