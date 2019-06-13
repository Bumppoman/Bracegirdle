class ExhibitSheetPdf < BasicPdf
  MARGIN_Y = 36
  MARGIN_X = 56

  def initialize(params, **options)
    @params = params
    @options = options

    text_box "Exhibit #{params[:exhibit]}", valign: :center, align: :center, size: 42
  end
end