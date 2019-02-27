class NoticePDF < DefaultPDF
  def content
    super

    font 'Arial'

    # Generic information
    text "\nNOTICE OF NON-COMPLIANCE", size: 22, align: :center, style: :bold, leading: 30
    text "Non-Compliance Number:  #{@params['notice_number']}", size: 18, align: :right, style: :bold, leading: 20
    text "Cemetery Name:  <b>#{@params['cemetery_name']}</b>", inline_format: true
    text "Cemetery Number:  <b>##{@params['cemetery_number']}</b>", inline_format: true
    text "Date of Issue:  <b>#{@params['notice_date']}</b>", inline_format: true
    text "\nServed On:        <b>#{@params['served_on_name']}, #{@params['served_on_title']}</b>", inline_format: true
    text @params['served_on_street_address'], indent_paragraphs: 87, style: :bold
    text "#{@params['served_on_city']}, #{@params['served_on_state']} #{@params['served_on_zip']}", indent_paragraphs: 87, style: :bold
    text "\n\nA written statement of compliance is required by <b>#{@params['response_required_date']}</b>.  Failure to respond will result in formal notification to the New York State Cemetery Board.", inline_format: true
    text "\nYou are hereby ordered to correct such non-compliance and to show proof that violations have been corrected.  Your notice of compliance is to be sent to the district office located at the following address:"
    text "\nDivision of Cemeteries\n#{@params['response_street_address']}\n#{@params['response_city']}, NY #{@params['response_zip']}"

    # Law violations
    start_new_page
    text "The above captioned cemetery was found to be out of compliance with the Not for Profit Corporation Law and/or Section 19 NYCRR as follows:"
    bounding_box [bounds.left + 60, bounds.top - 50], width: bounds.width - 60 do
      text @params['law_sections']
    end

    # Specific information
    start_new_page
    text "Specific information: #{@params['specific_information']}"
    text "\n\nI affirm that I identified this non-compliance with the Not for Profit Corporation Law and/or Section 19 NYCRR on #{@params['violation_date']}."
    text "\n\n\n\n\n#{@params['investigator_name']}\n#{@params['investigator_title']}, NYS Department of State\nDivision of Cemeteries"
    text "\nBy authority of #{officials['director']}, Director"

    # Response page
    start_new_page
    text "I affirm that I represent the above named cemetery corporation, and that we have resolved the above offenses in the following manner:\n\n\n"
    15.times do
      text '_________________________________________________________________________________', leading: 12
    end
    text "\n\n\n\n\n__________________________________                          __________________________________"
    text '(Signature and Title)                                                              (Date)'
  end
end