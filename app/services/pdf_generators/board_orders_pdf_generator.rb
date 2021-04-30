module PDFGenerators
  class BoardOrdersPDFGenerator < ApplicationService
    attr_reader :board_meeting
    
    def initialize(board_meeting)
      @board_meeting = board_meeting
    end
    
    def call
      output = CombinePDF.new
      
      @board_meeting.matters.each do |matter|
        case matter.board_application_type
          when 'Restoration'
            output << CombinePDF.parse(
              BoardOrders::DangerousMonumentBoardOrderPDF.new(
                {
                  matter: matter
                }
              ).render
            )
        end
      end
      
      output
    end
  end
end