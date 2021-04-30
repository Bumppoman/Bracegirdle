class BoardOrders::DangerousMonumentBoardOrderPDF < BoardOrderPDF
  def content
    super
    
    font 'Arial'
    
    # Title and introductory paragraphs
    move_up 25
    text "\nDANGEROUS MONUMENT ORDER", size: 18, align: :center, style: :bold, leading: 30
    text "By application dated #{@params[:matter].board_application.submission_date}, #{@params[:matter].cemetery.name}, \
#{@params[:matter].cemetery.county_name} County (Cemetery ID #{@params[:matter].cemetery.formatted_cemid}), requested \
funds for the repair or removal of monuments or markers that are so badly out of repair or dilapidated as to create a \
dangerous condition under Section 1507(h)(6) of the New York State Not-for-Profit Corporation Law."
    text "\nThe Cemetery Board has reviewed the application, reports, and appraisals and has determined that the request for funds is fair and reasonable."
    text "\nTherefore, pursuant to Section 1507(h)(6) of the Not-For-Profit Corporation Law, the request is approved as follows, with payments to be made when funds are available:"
    
    # Request table
    move_down 15
    table(
      [
        ["REQUESTED AMOUNT", "ALLOCATED AMOUNT"],
        [
          ActionController::Base.helpers.number_to_currency(@params[:matter].board_application.amount), 
          ActionController::Base.helpers.number_to_currency(@params[:matter].board_application.amount)
        ]
      ],
      width: bounds.width
    ) do
      cells.align = :center
      cells.borders = []
    end
    
    # Final paragraph
    text "\nWithin 90 days of its receipt of disbursements, the cemetery shall make a report to the Cemetery Board setting \
forth the repairs or removals and replacements made and by whom, the amount of funds expended, and the amount of funds to be \
returned to the Cemetery Board, if any. If any monuments or other markers have been removed, the report shall include a \
statement that they have been replaced with a flush bronze or granite marker suitably inscribed if replacement is \
appropriate for identification purposes. If the repairs and removals have not been completed, the reason therefor shall \
be set forth, and the anticipated date for a subsequent, final report shall be disclosed. Such report and any additional \
report shall be sworn by a cemetery officer."

    # Signature area
    bounding_box([bounds.width * 0.4, y - 55], width: bounds.width * 0.6) do
      text 'CEMETERY BOARD', align: :center
      text "\n#{officials['secretary_of_state']}, Secretary of State"
      move_down 15
      text "BY: ____________________________________________"
      text "#{officials['secretary_of_state_designee']}, Chairman", align: :center, size: 8
      text "\n#{officials['attorney_general']}, Attorney General"
      move_down 15
      text "BY: ____________________________________________"
      text officials['attorney_general_designee'], align: :center, size: 8
      text "\n#{officials['commissioner_of_health']}, Commissioner of Health"
      move_down 15
      text "BY: ____________________________________________"
      text officials['commissioner_of_health_designee'], align: :center, size: 8
    end
    
    move_up 20
    text "FILED: #{@params[:matter].board_meeting.date}"
  end
end