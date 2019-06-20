class Letters::CemeteryInspectionViolationsPdf < Letters::LetterPdf
  def letter_body
    text "\nRE: #{@params[:cemetery].name}, ##{@params[:cemetery].cemetery_id}"
    text "\nDear Cemeterian,"
    text "\nRecently, a representative of the New York State Department of State, Division of Cemeteries (the Division) inspected the above-referenced cemetery.  The Division noted certain potential violations of the Not-for-Profit Corporation Law and/or other conditions that need to be addressed.  These are listed on the following page(s).  Please address these concerns within 30 days and notify the Division in writing that they have been addressed.  We thank you in advance for your attention to these matters.", indent_paragraphs: 34
    text 'Please note that this inspection concerned the physical appearance of the grounds as well as the record keeping for the cemetery, and did not address its financial condition.', indent_paragraphs: 34
    text 'The administration of not-for-profit cemetery corporations is a time consuming, often thankless task.  We appreciate your acceptance of the responsibilities that go with the operation and maintenance of this not-for-profit cemetery.', indent_paragraphs: 34
  end
end