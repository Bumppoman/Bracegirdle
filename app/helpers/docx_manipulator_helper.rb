require 'zip'
require 'nokogiri'

module DocxManipulatorHelper
  def update_docx(template, params)

    # Open file and unzip it
    @zip_file = Zip::File.open(template)

    # Start updating the file
    buffer = Zip::OutputStream.write_buffer do |out|
      @zip_file.entries.each do |e|

        if e.name == "word/document.xml"

          # Parse the XML
          @xml_doc = Nokogiri::XML.parse(e.get_input_stream.read)

          # Iterate through the params and update
          @xml_doc.xpath('//w:t[@id[starts-with(., "bracegirdle_")]]').each do |element|
            variable_name = element.attributes['id'].value.sub(/^bracegirdle_/, '')
            element.content = params[variable_name] || params[variable_name.to_sym]
          end
        elsif e.directory?
          next
        else
          out.put_next_entry(e.name)
          out.write e.get_input_stream.read
        end
      end

      out.put_next_entry("word/document.xml")
      out.write @xml_doc.to_xml(:indent => 0).gsub("\n", "")
    end

    @zip_file.close

    # Return the data for streaming
    buffer.string
  end
end
