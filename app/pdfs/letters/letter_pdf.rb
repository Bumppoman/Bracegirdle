class Letters::LetterPDF < DefaultPDF
  def content
    super

    address
    letter_body
    signature
  end

  def letter_body; end

  protected

  def address
    text "\n\n\n#{@params.dig(@options.dig(:date)) || @params[:date]}\n\n"
    text @params.dig(@options.dig(:recipient)) || @params[:recipient]
    text @params[:address_line_one]
    text @params[:address_line_two]
  end

  def signature
    text "\n\n\nSincerely,\n"

    if @params[:signature]
      bounding_box [bounds.left, cursor-10], width: 300 do
        image Rails.root.join('app', 'pdfs', 'signatures', @params[:signature]), height: 38, width: 140
      end
    end

    text "\n#{@params[:name]}"
    text "#{@params[:title]}, NYS Department of State\nDivision of Cemeteries"
  end
end