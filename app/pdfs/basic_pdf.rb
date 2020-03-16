class BasicPDF
  include Prawn::View

  def document
    font_directory = Rails.root.join('app', 'pdfs', 'fonts')
    @document ||= Prawn::Document.new(margin: [self.class::MARGIN_Y, self.class::MARGIN_X])
    @document.font_families.update("Arial" => {
        :normal => font_directory.join('Arial.ttf'),
        :italic => font_directory.join('Arial Italic.ttf'),
        :bold => font_directory.join('Arial Bold.ttf'),
        :bold_italic => font_directory.join('Arial Bold Italic.ttf')
    })
    @document
  end

  protected

  def checkbox(x, y, selected = false)
    bounding_box([x, y], width: 5, height: 5) do
      stroke_bounds
      text 'x', align: :center, size: 5, style: :bold if selected
    end
  end

  def signature(signature, x, y)
    bounding_box [x, y], width: 300 do
      image Rails.root.join('app', 'pdfs', 'signatures', signature), height: 38, width: 140
    end
  end

  def smallcaps(string)
    string = string.tr('a-z', 'ᴀʙᴄᴅᴇғɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ')
    string.gsub(/ғ/, '<font size="5.9125">F</font>')
  end
end
