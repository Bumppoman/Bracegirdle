class BlankPDF
  include Prawn::View

  def initialize(params, **options)
    @params = params
    @options = options
  end
end
