class Reports::ReportPDF < DefaultPDF
  def content
    super
    report_heading
    list_exhibits
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
        lettered_exhibits << ["#{@exhibit_letters[i]})", d[0]]
      end

      bounding_box [bounds.left, cursor - 10], width: bounds.width - 20 do
        t = make_table(lettered_exhibits, {:cell_style => { :borders => [], :align => :justify, :padding => [0,10,0,0]}, header: true})
        indent(20) {t.draw}
      end

      #exhibits.each_with_index do |exhibit, i|
      #  bounding_box [bounds.left + 22, cursor], width: bounds.width - 60 do
      #    text "\n#{@exhibit_letters[i]}) #{exhibit[0]}"
      #  end
      #end
    end
  end

  def report_heading
    text "\n\n\nDEPARTMENT OF STATE - DIVISION OF CEMETERIES\n\nMEMORANDUM", style: :bold, align: :center
    text "\n\n\n<b>TO:</b>  New York State Cemetery Board", inline_format: true
    text "\n<b>FROM:</b>  #{@params[:writer_name]}, #{@params[:writer_title]}", inline_format: true
    text "\n<b>SUBJECT:</b>  #{@params[:cemetery_name]}, ##{@params[:cemetery_number]}", inline_format: true
    text "\n<b>RE:</b>  #{@regarding}", inline_format: true
    text "\n<b>DATE:</b>  #{@params[:report_date]}", inline_format: true
  end
end