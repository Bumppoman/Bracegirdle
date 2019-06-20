class Letters::CemeteryInspectionNoViolationsPdf < Letters::LetterPdf
  def letter_body
    text "\nRE: #{@params[:cemetery].name}, ##{@params[:cemetery].cemetery_id}"
    text "\nDear Cemeterian,"
    text "\nRecently, a representative of the New York State Department of State, Division of Cemeteries (the Division) inspected the above-referenced cemetery.  During this inspection, no violations of the Not-for-Profit Corporation Law were noted.  This inspection concerned the physical appearance of the grounds as well as the record keeping procedures of the cemetery, and did not address its financial condition.", indent_paragraphs: 34
    text 'The administration of not-for-profit cemetery corporations is a time consuming, often thankless task.  We appreciate your acceptance of the responsibilities that go with the operation and maintenance of this not-for-profit cemetery.', indent_paragraphs: 34
  end
end