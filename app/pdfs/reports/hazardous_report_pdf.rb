class Reports::HazardousReportPdf < Reports::ReportPdf
  def initialize(*args)
    @regarding = 'Application for Repair of Hazardous Monuments'
    super
  end

  def report_body
    text "<u>Introduction and Recommendation</u>", style: :bold, inline_format: true
    intro = "\nI received an application (Exhibit A) for the repair of #{@params[:restoration].monuments} hazardous monuments \
located in the #{@params[:cemetery].name} of the #{'town'.pluralize(@params[:cemetery].towns.count)} of \
#{@params[:cemetery].towns.to_sentence}, #{@params[:cemetery].county_name} County.  The application was submitted by \
#{@params[:restoration].trustee_name}, #{Trustee::POSITIONS[@params[:restoration].trustee_position].downcase} of the #{@params[:cemetery].name}.  \
Included with this application were #{@params[:restoration].estimates.length.to_words} \
#{'estimate'.pluralize(@params[:restoration].estimates.length)}:  "
    letters = ('B'..'Z').to_a
    @params[:restoration].estimates.each_with_index do |estimate, i|
      intro << 'and ' if i == @params[:restoration].estimates.length - 1
      intro << "one from #{estimate.contractor.name} (Exhibit #{letters.shift}) for #{ActionController::Base.helpers.number_to_currency(estimate.amount)}"
      intro << '; ' unless i == @params[:restoration].estimates.length - 1
    end
    intro << ".  Also included was an invoice from #{@params[:restoration].legal_notice_newspaper.with_indefinite_article} newspaper legal notice \
(Exhibit #{letters.shift}) that was run for three consecutive weeks for \
#{ActionController::Base.helpers.number_to_currency(@params[:restoration].legal_notice_cost)}."
    text intro, indent_paragraphs: 38
    text 'I recommend approval of this application.', indent_paragraphs: 38

    start_new_page
    text "\n<u>The Monuments</u>", style: :bold, inline_format: true
    text "\nI visited the cemetery on #{@params[:restoration].field_visit_date} and found that all #{@params[:restoration].monuments} of the monuments \
were either loose on their foundations or tipping and appeared to pose a hazard to cemetery visitors and employees.  The cemetery has had \
no response to the legal advertisement which it placed, and has no funds dedicated to the restoration of monuments.  Based on the advanced \
age of the monuments in question, it is assumed the foundations were laid privately by either the families or by monument contractors.", indent_paragraphs: 38
    specs = "All estimates propose to:  remove the monuments from the existing foundations; dig out the existing foundation; place a new \
foundation made of solid concrete poured to a depth of 42 inches; and replace the monument, resealing all joints with setting compound or epoxy.  "
    specs << warranty
    specs << '.'
    text specs, indent_paragraphs: 38

    text "\n\n<u>Recommendation</u>\n\n", style: :bold, inline_format: true
    recommendation = 'The cemetery is current with its payments to the vandalism fund and with the filing of its annual reports.  '
    if (@params[:restoration].previous_exists?)
      recommendation << "The cemetery previously received a disbursement for #{@params[:restoration].formatted_previous_type} work in \
#{@params[:restoration].previous_date}, and the funds were spent appropriately (Exhibit #{letters.shift}).  "
    end
    recommendation << "All documents appear to be in order, and this appears to be a legitimate claim for \
#{ActionController::Base.helpers.number_to_currency(@params[:restoration].calculated_amount)}.  I recommend that this application be approved."
    text recommendation, indent_paragraphs: 38
  end

  protected

  def build_exhibits
    exhibits = [
      'Application for Repair or Removal of Dilapidated or Disrepaired Monuments that Create a Hazardous Condition'
    ]

    @params[:restoration].estimates.each do |estimate|
      exhibits << "#{estimate.contractor.name} estimate for #{ActionController::Base.helpers.number_to_currency(estimate.amount)}"
    end

    exhibits << "Invoice and copy from #{@params[:restoration].legal_notice_newspaper} legal notice \
for #{ActionController::Base.helpers.number_to_currency(@params[:restoration].legal_notice_cost)}"
    exhibits << "Completion report for previous #{@params[:restoration].formatted_previous_type} work \
awarded in #{@params[:restoration].previous_date}" if @params[:restoration].previous_exists?

    exhibits
  end

  def warranty
    if @params[:restoration].estimates.length == 2
      if @params[:restoration].estimates[0].warranty == @params[:restoration].estimates[1].warranty
        "Both #{@params[:restoration].estimates[0].contractor.name} and #{@params[:restoration].estimates[1].contractor.name} offer \
a #{@params[:restoration].estimates[0].warranty.to_words}-year warranty"
      else
        "#{@params[:restoration].estimates[0].contractor.name} offers a #{@params[:restoration].estimates[0].warranty.to_words}-year warranty, \
while #{@params[:restoration].estimates[1].contractor.name} offers a #{@params[:restoration].estimates[1].warranty.to_words}-year warranty"
      end
    else
      warranty = "The contractors' warranties are as follows:  "
      @params[:restoration].estimates.each_with_index do |estimate, i|
        warranty << 'and ' if i == @params[:restoration].estimates.length - 1
        warranty << "#{estimate.contractor.name} offers a #{estimate.warranty.to_words}-year warranty"
        warranty << '; ' unless i == @params[:restoration].estimates.length - 1
      end

      warranty
    end
  end
end