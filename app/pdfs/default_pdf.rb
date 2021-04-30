class DefaultPDF < ApplicationPDF
  MARGIN_Y = 36
  MARGIN_X = 56

  def initialize(params, **options)
    @params = params
    @options = options

    font_size 11

    content

    repeat :all do
      footer
    end
  end

  def content
    header
  end
  
  protected
  
  def officials
    @officials ||= YAML.load_file(Rails.root.join('config', 'letterhead.yml'))['letterhead']
  end

  private

  def footer
    bounding_box [bounds.left, bounds.bottom + 55], width: bounds.width do
      image Rails.root.join('app', 'javascript', 'images', 'cemeteries-logo.jpg'), height: 55, width: 193, position: :center
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
end
