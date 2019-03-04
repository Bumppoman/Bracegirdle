class Reports::ReportPDF < DefaultPDF
  def content
    super
    report_heading
    list_exhibits
    report_body
  end

  def report_body; end

  protected

  def list_exhibits
    exhibits = build_exhibits
    if exhibits.any?
      text "\n\n<u>Exhibits</u>", style: :bold, inline_format: true
      @exhibit_letters = ('A'..'Z').to_a
      lettered_exhibits = []

      exhibits.each_with_index do |d, i|
        lettered_exhibits << ["#{@exhibit_letters[i]})", d]
      end

      #raise lettered_exhibits.inspect
      bounding_box [bounds.left, cursor - 10], width: bounds.width - 20 do
        t = make_table(lettered_exhibits, {:cell_style => { :borders => [], :align => :justify, :padding => [0,10,0,0]}, header: true})
        indent(20) {t.draw}
      end

      text "\n\n"
    end
  end

  def report_heading
    text "\n\n\nDEPARTMENT OF STATE - DIVISION OF CEMETERIES\n\nMEMORANDUM", style: :bold, align: :center
    text "\n\n\n<b>TO:</b>  New York State Cemetery Board", inline_format: true
    text "\n<b>FROM:</b>  #{@params[:writer].name}, #{@params[:writer].title}", inline_format: true
    text "\n<b>SUBJECT:</b>  #{@params[:cemetery].name}, ##{@params[:cemetery].cemetery_id}", inline_format: true
    text "\n<b>RE:</b>  #{@regarding}", inline_format: true
    text "\n<b>DATE:</b>  #{@params[:report_date]}", inline_format: true
  end
end