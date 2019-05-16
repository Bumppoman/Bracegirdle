class ExhibitSheetPdf
  include Prawn::View

  def initialize(params, **options)
    @params = params
    @options = options

    text_box "Exhibit #{params[:exhibit]}", valign: :center, align: :center, size: 42
  end

  def document
    font_directory = Rails.root.join('app', 'pdfs', 'fonts')
    @document ||= Prawn::Document.new(margin: [36, 56])
    @document.font_families.update("Arial" => {
        :normal => font_directory.join('Arial.ttf'),
        :italic => font_directory.join('Arial Italic.ttf'),
        :bold => font_directory.join('Arial Bold.ttf'),
        :bold_italic => font_directory.join('Arial Bold Italic.ttf')
    })
    @document
  end
end