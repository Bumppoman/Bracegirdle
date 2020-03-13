class AgendaPdf < DefaultPdf
  def content
    super

    font 'Arial'

    move_down 30
    text 'CEMETERY BOARD MEETING AGENDA', size: 12, align: :center
    text @params.date.strftime('%B %-d, %Y at %R %p'), size: 12, align: :center

    move_down 15
    text @params.location, size: 12, align: :center, style: :bold_italic

    move_down 30
    text 'Opening Remarks', indent_paragraphs: 25

    move_down 15
    indent(20) do
      table(
        [
          ["#{@params.date_code}–A–#{@params.initial_index}", 'Minutes of Previous Meeting'],
          ["#{@params.date_code}–B–#{@params.initial_index + 1}", 'Legislation and Regulation'],
          ['',
            make_table([
              ['1. Pending Legislation'],
              ['2. Rules and Regulations'],
            ]) do
              cells.borders = []
              cells.padding_bottom = 0
            end
          ],
          ["#{@params.date_code}–C–#{@params.initial_index + 2}", 'Division Report'],
          ['',
            make_table([
              ['1. Annual Mailing – Update'],
              ['2. Quarterly Report'],
              ['3. Staffing']
            ]) do
              cells.borders = []
              cells.padding_bottom = 0
            end
          ],
          ["#{@params.date_code}–D–#{@params.initial_index + 3}", 'Vandalism, Abandonment and Monument Repair or Removal Fund Report'],
          ['', "Vandalism/Abandoned/Repair Orders – #{@params.restoration.count}"]
        ]
      ) do
        cells.borders = []
        rows([0, 2, 4]).padding_bottom = 15
      end
    end

    indent(25) do
      @params.matters.each do |matter|
        if (y > (bounds.bottom + 125))
          move_down 15
        else
          start_new_page
        end
        text "#{matter.identifier} #{matter.cemetery.name} (##{matter.cemetery.cemetery_id}) – #{matter.application.formatted_application_type}"
      end

      move_down 15
      text 'Public Comment'
    end

    start_new_page

    move_down 10
    text "DEPARTMENT OF STATE", align: :center
    text "DIVISION OF CEMETERIES", align: :center
    text @params.date.to_s, align: :center

    move_down 30
    text "TO:            #{@officials['secretary_of_state_designee']}, Chairman, for Hon. #{@officials['secretary_of_state']}, Secretary of State"
    indent 55 do
      text "#{@officials['commissioner_of_health_designee']}, for Hon. #{@officials['commissioner_of_health']}, Commissioner of Health"
      text "#{@officials['attorney_general_designee']}, for Hon. #{@officials['attorney_general']}, Attorney General"
    end

    move_down 20
    text "FROM:       #{@officials['director']}, Director"
    text "#{@officials['assistant_director']}, Assistant Director", indent_paragraphs: 56

    move_down 20
    text "RE:            Proposed        Dangerous–#{@params.hazardous_count}        Abandoned–#{@params.abandonment_count}         Vandalism–#{@params.vandalism_count}"

    move_down 20
    text 'VANDALISM FUND APPLICATIONS', align: :center
    table_data = [['Name', 'Amount', 'County', 'ID No.']]
    total = 0
    @params.restoration.each do |restoration|
      total += restoration.application.amount
      table_data << [restoration.cemetery.name, ActionController::Base.helpers.number_to_currency(restoration.application.amount), restoration.cemetery.county_name, restoration.cemetery.cemetery_id]
    end
    table_data << ['Total', { content: ActionController::Base.helpers.number_to_currency(total), colspan: 3 }]

    bounding_box([bounds.left, y - 55], width: bounds.width) do
      table(
        table_data,
        column_widths: [bounds.width * 0.4, bounds.width * 0.2, bounds.width * 0.2, bounds.width * 0.2],
        width: bounds.width
      )
    end
  end
end
