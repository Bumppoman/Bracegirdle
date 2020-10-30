class CemeteryInspectionItemsPDF < BasicPDF
  MARGIN_Y = 41
  MARGIN_X = 56

  def initialize(params, **options)
    @params = params
    @options = options

    font_size 11

    content
  end

  def content
    font 'Arial'
    text '<u>Items for Consideration</u>', align: :center, size: 18, inline_format: true
    move_down 20

    item_number = 1
    items = YAML.load_file(Rails.root.join('config', 'cemetery_inspections.yml'))['cemetery_inspections'].select do |k, v| 
      v.has_key? 'law_section'
    end
    
    items.each do |item, values|
      if values['conditions']
        values['conditions'].each do |condition, value|
          next unless !@params[:inspection].send(condition).nil? && @params[:inspection].send(condition) == value
        end
      else
        next if @params[:inspection].send(item)
      end

      start_new_page unless item_number == 1
      text "#{item_number}) #{values['report_text']}"

      unless values['law_section']['title'].is_a? Array
        values['law_section']['title'] = [values['law_section']['title']]
        values['law_section']['body'] = [values['law_section']['body']]
      end

      values['law_section']['title'].each_with_index do |title, i|
        bounding_box([bounds.left + 20, y - 60], width: bounds.width - 60) do
          text title, style: :bold, size: 9
          text "<br>#{values['law_section']['body'][i]}", size: 9, inline_format: true
        end
      end

      start_new_page
      item_number += 1
    end
  end
end
