class CemeteryInspectionReportPDF
  include Prawn::View

  def initialize(params, **options)
    @params = params
    @options = options

    font_size 10

    content
  end

  def content
    font 'Arial'

    bounding_box [bounds.left, bounds.top], width: bounds.width do
      image Rails.root.join('app', 'webpacker', 'images', 'cemeteries-logo.jpg'), height: 55, width: 193
    end

    bounding_box [bounds.right - 193, bounds.top - 20], width: bounds.width do
      text 'Field Inspection Report', size: 18
    end

    # Cemetery information
    move_down 25
    table(
      [
        [smallcaps('1. Cemetery'), smallcaps('County'), smallcaps('Number')],
        [' ', '', ''],
        [smallcaps('2. Interviewee'), smallcaps('Title'), smallcaps('Date')],
        [' ', '', ''],
        [{ content: smallcaps('3. Interviewee Address'), colspan: 2 }, smallcaps('Telephone Number')],
        [{ content: ' ', colspan: 2 }, ''],
        [{ content: smallcaps('4. Location of Cemetery'), colspan: 2 }, smallcaps('Email Address')],
        [{ content: ' ', colspan: 2 }, ''],
        [{ content: smallcaps('5. Sign'), colspan: 3 }],
        [{ content: ' ', colspan: 3 }]
      ],
      cell_style: { inline_format: true },
      column_widths: [bounds.width / 2, bounds.width / 4, bounds.width / 4],
      width: bounds.width) do
        rows([0, 2, 4, 6, 8]).padding = [0, 0, 0, 0]
        rows([0, 2, 4, 6, 8]).borders = [:top]
        rows([0, 2, 4, 6, 8]).size = 8

        rows([1, 3, 5, 7, 9]).borders = []
    end
    stroke_horizontal_rule
    move_down 10
    stroke_horizontal_rule

    # Physical attributes
    table(
      [
        [{ content: '', colspan: 3 }, 'REMARKS'],
        ['6. Sign displayed (19 NYCRR §201.7)', "#{smallcaps('yes')}", smallcaps('no'), ''],
        ['7. Administrative offices', "#{smallcaps('yes')}", smallcaps('no'), ''],
        ['8. Rules and regulations conspicuously displayed', smallcaps('yes'), smallcaps('no'), ''],
        ['9. Service charges and lot prices conspicuously displayed', "#{smallcaps('yes')}", smallcaps('no'), ''],
        ['10. Scattering gardens', "#{smallcaps('yes')}", smallcaps('no'), ''],
        ['11. Community mausoleum', "#{smallcaps('yes')}", smallcaps('no'), "<font size='8'>#{smallcaps('Condition')}</font>"],
        ["12. Proposed mausoleum (i.e., signs or architect's rendering)", "#{smallcaps('yes')}", smallcaps('no'), ''],
        ['13. Private mausoleum', "#{smallcaps('yes')}", smallcaps('no'), "<font size='8'>#{smallcaps('Condition')}</font>"],
        ['14. Lawn crypts', "#{smallcaps('yes')}", smallcaps('no'), "<font size='8'>#{smallcaps('Method of Approval')}</font>"],
        ['15. Grave liners', "#{smallcaps('yes')}", smallcaps('no'), "<font size='8'>#{smallcaps('Number Stored')}</font>"],
        ['16. Evidence of display or sale of monuments', "#{smallcaps('yes')}", smallcaps('no'), ''],
        ['17. Fencing', "#{smallcaps('yes')}", smallcaps('no'), "<font size='8'>#{smallcaps('Describe')}</font>"],
      ],
      cell_style: { border_lines: [:solid, :solid, :solid, :dotted], inline_format: true },
      column_widths: [bounds.width * 0.43, bounds.width * 0.06, bounds.width * 0.06, bounds.width * 0.45]
    ) do
      cells.borders = [:top]
      cells.height = 25
      column(0).size = 8
      columns([1, 2]).padding = [5, 5, 5, 0]
      columns([1, 2]).align = :right
      column(3).borders = [:top, :left]

      # Header row
      row(0).height = 20
      row(0).column(3).size = 8
      row(0).column(3).font_style = :bold

      rows([6, 8, 9, 10, 12]).column(3).padding = [0, 0, 0, 5]
    end
    stroke_horizontal_rule
    move_down 10
    stroke_horizontal_rule

    # Checkboxes
    [500.5, 475.5, 450.5, 425.5, 400.5, 375.5, 350.5, 325.5, 300.5, 275.5, 250.5, 225.5].each_with_index do |y, i|
      checkbox(245, y, false)
      checkbox(282, y, false)
    end

    move_down 21
    table(
        [
            [smallcaps('18. Main Road')],
            [' '],
            [smallcaps('19. Side Roads')],
            [' '],
            [smallcaps('20. Condition of New Memorials')],
            [' '],
            [smallcaps('21. Condition of Old Memorials')],
            [' '],
            [smallcaps('22. Evidence of Vandalism')],
            [' '],
            [smallcaps('23. Evidence of Hazardous Materials')],
            [' ']
        ],
        cell_style: { inline_format: true },
        width: bounds.width) do
      rows([0, 2, 4, 6, 8, 10]).padding = [0, 0, 0, 0]
      rows([0, 2, 4, 6, 8, 10]).borders = [:top]
      rows([0, 2, 4, 6, 8, 10]).size = 8

      rows([1, 3, 5, 7, 9, 11]).borders = []
    end
    stroke_horizontal_rule

    bounding_box([bounds.left, bounds.bottom], width: 40, height: 40) do
      text smallcaps('DOS-540'), size: 8
    end

    bounding_box([bounds.left, bounds.bottom], width: bounds.width, height: 40) do
      text '–– CONTINUED ON REVERSE ––', align: :center, size: 8, style: :bold
    end

    start_new_page

    # Create receiving vault table
    receiving_vaults = make_table(
      [
        ['YES –– If YES,', { content: 'NUMBER OF BODIES STORED:', colspan: 2 }],
        ['NO', "#{Prawn::Text::NBSP * 5}Clean, dry, free of vermin and rodents", "#{Prawn::Text::NBSP * 5}Used exclusively for human remains"],
        ['', "#{Prawn::Text::NBSP * 5}Obscured from public view", "#{Prawn::Text::NBSP * 5}Secured when unattended"]
      ],
      cell_style: { borders: [] },
      column_widths: [bounds.width * 0.15, bounds.width * 0.425, bounds.width * 0.425]
    )

    # Receiving vault
    move_down 20
    table(
      [
        [smallcaps('24. Receiving Vaults')],
        [receiving_vaults],
        [smallcaps('25. Overall Conditions (sinkage and overgrowth)')],
        [''],
        [smallcaps('26. Signs of Major Renovations')],
        ['']
      ],
      cell_style: { inline_format: true },
      width: bounds.width
    ) do
      rows([0, 2, 4]).padding = [0, 0, 0, 0]
      rows([0, 2, 4]).borders = [:top]
      rows([0, 2, 4]).size = 8

      rows([1, 3, 5]).borders = []
      row(1).column(0).padding = [0, 0, 10, 20]

      row(1).column(1).padding = [0, 40, 0, 0]

      rows([3, 5]).height = 80
    end

    checkbox(15, 715.5, false)
    checkbox(15, 694.5, false)
    checkbox(113, 694.5, false)
    checkbox(349, 694.5, false)
    checkbox(113, 673.5, false)
    checkbox(349, 673.5, false)

    move_down 200
    stroke_horizontal_rule
    move_down 10
    stroke_horizontal_rule

    # Record-keeping
    table(
      [
        [{ content: '', colspan: 3 }, 'REMARKS'],
        ['27. Annual meetings held and advertised', "#{smallcaps('yes')}", smallcaps('no'), "<font size='8'>#{smallcaps('Newspaper')}</font>"],
        ['28. Election held', "#{smallcaps('yes')}", smallcaps('no'), ''],
        ['29. Burial permits filed within 7 days', smallcaps('yes'), smallcaps('no'), ''],
        ['30. Body delivery receipt issued', "#{smallcaps('yes')}", smallcaps('no'), ''],
        ['31. Deeds signed by president and treasurer', "#{smallcaps('yes')}", smallcaps('no'), ''],
        ['32. Burial book and map kept up-to-date', "#{smallcaps('yes')}", smallcaps('no'), "<font size='8'>#{smallcaps('Location')}</font>"],
        ["33. Rules and regulations provided with deed", "#{smallcaps('yes')}", smallcaps('no'), ''],
        ['34. Rules and regulations approved by Division', "#{smallcaps('yes')}", smallcaps('no'), "<font size='8'>#{smallcaps('Last Updated')}</font>"],
      ],
      cell_style: { border_lines: [:solid, :solid, :solid, :dotted], inline_format: true },
      column_widths: [bounds.width * 0.43, bounds.width * 0.06, bounds.width * 0.06, bounds.width * 0.45]
    ) do
      cells.borders = [:top]
      cells.height = 25
      column(0).size = 8
      columns([1, 2]).padding = [5, 5, 5, 0]
      columns([1, 2]).align = :right
      column(3).borders = [:top, :left]

      # Header row
      row(0).height = 20
      row(0).column(3).size = 8
      row(0).column(3).font_style = :bold

      rows([1, 6, 8]).column(3).padding = [0, 0, 0, 5]
    end
    stroke_horizontal_rule
    move_down 10
    stroke_horizontal_rule

    [429.5, 404.5, 379.5, 354.5, 329.5, 304.5, 279.5, 254.5].each_with_index do |y, i|
      checkbox(245, y, false)
      checkbox(282, y, false)
    end

    # Receiving vault
    move_down 21
    table(
        [
            [smallcaps('35. Items for Consideration of the Cemetery')],
            [' '],
            [smallcaps('36. Date Letter Sent')],
            [' ']
        ],
        cell_style: { inline_format: true },
        width: bounds.width
    ) do
      rows([0, 2, 4]).padding = [0, 0, 0, 0]
      rows([0, 2, 4]).borders = [:top]
      rows([0, 2, 4]).size = 8

      rows([1, 3, 5]).borders = []
      row(1).column(0).padding = [0, 0, 10, 20]

      row(1).column(1).padding = [0, 40, 0, 0]

      row(1).height = 100
    end
    stroke_horizontal_rule
    move_down 100

    # Signature area
    stroke_horizontal_line(0, 275, at: y)
    stroke_horizontal_line(bounds.width - 225, bounds.width, at: y)
    bounding_box([bounds.left, y - 5], width: 60, height: 40) do
      text smallcaps('Investigator'), size: 8
    end
    bounding_box([bounds.width - 225, y+20], width: 40, height: 40) do
      text smallcaps('Date'), size: 8
    end
  end

  def document
    font_directory = Rails.root.join('app', 'pdfs', 'fonts')
    @document ||= Prawn::Document.new(margin: [20, 28])
    @document.font_families.update("Arial" => {
        :normal => font_directory.join('Arial.ttf'),
        :italic => font_directory.join('Arial Italic.ttf'),
        :bold => font_directory.join('Arial Bold.ttf'),
        :bold_italic => font_directory.join('Arial Bold Italic.ttf')
    })
    @document
  end

  private

  def checkbox(x, y, selected = false)
    bounding_box([x, y], width: 5, height: 5) do
      stroke_bounds
      text 'x', align: :center, size: 5, style: :bold if selected
    end
  end

  def smallcaps(string)
    string = string.tr('a-z', 'ᴀʙᴄᴅᴇғɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ')
    string.gsub(/ғ/, '<font size="5.9125">F</font>')
  end
end