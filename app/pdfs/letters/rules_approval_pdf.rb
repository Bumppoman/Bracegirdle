class Letters::RulesApprovalPDF < Letters::LetterPDF
  def letter_body
    text "\nRE: #{@params[:cemetery_name]}, ##{@params[:cemetery_number]}"
    text "\nDear Cemeterian,"
    text "\nBy request received #{@params[:submission_date]}, the #{@params[:cemetery_name]} submitted rules and regulations for approval by the Cemetery Board.  Pursuant to Section 1509(c) of the Not for Profit Corporation Law, and Section 200.2 of the Rules of Procedure of the State Cemetery Board, these rules and regulations are hereby approved.", indent_paragraphs: 34
    text 'A copy of these rules and regulations must be supplied with every deed issued by the cemetery, and must be available for review at the cemetery’s annual meeting.', indent_paragraphs: 34
  end
end