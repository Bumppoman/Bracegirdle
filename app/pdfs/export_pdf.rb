class ExportPDF
  include Prawn::View

  def initialize
    font_families.update("Arial" => {
        :normal => "/Library/Fonts/Arial.ttf",
        :italic => "/Library/Fonts/Arial Italic.ttf",
        :bold => "/Library/Fonts/Arial Bold.ttf",
        :bold_italic => "/Library/Fonts/Arial Bold Italic.ttf"
    })

    content
    repeat :all do
      footer
    end
  end

  def content
    header
  end

  private

  def footer
    bounding_box [bounds.left, bounds.bottom + 55], width: bounds.width do
      image Rails.root.join('app', 'webpacker', 'images', 'cemeteries-logo.jpg'), height: 55, width: 193, position: :center
    end
  end

  def header
    bounding_box [bounds.left, bounds.top], width: bounds.width do
      font 'Arial'
      character_spacing 0.75 do
        text 'DIVISION OF CEMETERIES', size: 10, style: :bold
        text 'STATE OF NEW YORK', size: 8
        text 'DEPARTMENT OF STATE', size: 8, style: :bold
        text "Oɴᴇ Cᴏᴍᴍᴇʀᴄᴇ Pʟᴀᴢᴀ\n99 Wᴀsʜɪɴɢᴛᴏɴ Aᴠᴇɴᴜᴇ\nAʟʙᴀɴʏ, NY 12231-0001\nTᴇʟᴇᴘʜᴏɴᴇ: (518) 474-6226\nFᴀx: (518) 473-0876\nᴡᴡᴡ.ᴅᴏs.ɴʏ.ɢᴏᴠ", size: 8
      end
    end

    bounding_box [bounds.right-150, bounds.top], width: 150 do
      font 'Arial'
      character_spacing 0.75 do
        text smallcaps(officials['governor']), size: 8, align: :right, inline_format: true
        text "Gᴏᴠᴇʀɴᴏʀ", size: 6, align: :right, leading: 4
        text 'CEMETERY BOARD', size: 7, align: :right, leading: 2
        text smallcaps(officials['secretary_of_state']), size: 8, align: :right, inline_format: true, leading: -1
        text 'Sᴇᴄʀᴇᴛᴀʀʏ ᴏ<font size="4.3125">F</font> Sᴛᴀᴛᴇ', size: 6, align: :right, inline_format: true
        text 'Cʜᴀɪʀ', size: 6, align: :right, leading: 2
        text smallcaps(officials['attorney_general']), size: 8, align: :right, inline_format: true, leading: -1
        text 'Aᴛᴛᴏʀɴᴇʏ Gᴇɴᴇʀᴀʟ', size: 6, align: :right, leading: 2
        text smallcaps(officials['commissioner_of_health']), size: 8, align: :right, inline_format: true, leading: -1
        text 'Cᴏᴍᴍɪssɪᴏɴᴇʀ ᴏ<font size="4.3125">F</font> Hᴇᴀʟᴛʜ', size: 6, align: :right, inline_format: true
      end
    end
  end

  def officials
    @officials ||= YAML.load_file(Rails.root.join('config', 'letterhead.yml'))['letterhead']
  end

  def smallcaps(string)
    string = string.tr('a-z', 'ᴀʙᴄᴅᴇғɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ')
    string.gsub(/ғ/, '<font size="5.9125">F</font>')
  end
end