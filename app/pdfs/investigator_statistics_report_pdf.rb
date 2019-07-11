class InvestigatorStatisticsReportPdf < BasicPdf
  MARGIN_Y = 30
  MARGIN_X = 38

  def initialize(params, **options)
    @params = params
    @options = options

    # Get statistics
    month_range = Date.civil(@params[:year], @params[:month], 1)...Date.civil(@params[:year], @params[:month] + 1, 1)
    @complaints = {}
    @complaints[:closed] = Complaint.joins(:status_changes).where(investigator: params[:investigator], 'status_changes.created_at': month_range, 'status_changes.status': [Complaint.statuses[:closed], Complaint.statuses[:pending_closure]])
    @complaints[:active] = @params[:investigator].complaints
    @complaints[:total_closed] = Complaint.where(investigator: @params[:investigator], status: [:pending_closure, :closed])
    @complaints[:total_time] = @complaints[:total_closed].map { |c| (c.disposition_date - c.created_at.to_date).to_i }.inject(0, :+)
    begin
      @complaints[:average_time] = @complaints[:total_time] / @complaints[:total_closed].count
    rescue ZeroDivisionError
      @complaints[:average_time] = 0
    end

    @inspections = {}
    @inspections[:completed] = CemeteryInspection.where(investigator: @params[:investigator], date_mailed: month_range)
    @inspections[:incomplete] = CemeteryInspection.where(investigator: @params[:investigator], date_performed: month_range).where.not(status: :complete)

    @rules = {}
    @rules[:approved] = Rules.where(investigator: @params[:investigator], approval_date: month_range)
    @rules[:unreviewed] = Rules.pending_review_for(@params[:investigator])
    @rules[:total_approved] = Rules.where(investigator: @params[:investigator], status: :approved).where.not(submission_date: nil)
    @rules[:total_time] = @rules[:total_approved].map { |r| (r.approval_date - r.submission_date).to_i }.inject(0, :+)
    begin
      @rules[:average_time] = @rules[:total_time] / @rules[:total_approved].count
    rescue ZeroDivisionError
      @rules[:average_time] = 0
    end

    font_size 10

    content
  end

  def content
    font 'Arial'

    bounding_box [bounds.left, bounds.top], width: bounds.width do
      image Rails.root.join('app', 'javascript', 'images', 'cemeteries-logo.jpg'), height: 55, width: 193
    end

    bounding_box [bounds.right - 193, bounds.top - 20], width: bounds.width do
      text 'Investigator Statistics', size: 18
    end

    move_down 40

    text "Investigator:  #{@params[:investigator].name}", indent_paragraphs: 20, leading: 3
    text "Period:  #{@params[:month_name]} #{@params[:year]}", indent_paragraphs: 20

    move_down 25

    table(
      [
        ['Complaints',
          make_table(
            complaints_table_data,
            cell_style: { size: 8 }
          ) do
            row(0).padding_bottom = 2
            row(-2).padding_top = 0
            cells.borders = []
          end
        ],
        ['Inspections',
          make_table(
            inspections_table_data,
            cell_style: { size: 8 },
          ) do
            row(-2).padding_top = 0
            row(-2).padding_bottom = 0
            row(-1).padding_top = 2
            cells.borders = []
          end
        ],
        ['Rules',
          make_table(
            rules_table_data,
            cell_style: { size: 8 }
          ) do
            cells.borders = []
          end
        ]
      ],
      column_widths: [bounds.width * 0.3, bounds.width * 0.7],
      width: bounds.width
    ) do
      column(0).padding = 10
      column(1).padding = 5
    end

    move_down 60

    bounding_box [bounds.left, y], width: bounds.width / 2 - 30 do
      text "Average Time to Complete\n\n", align: :center
      data = {
        'Time (days)' => {
          'Complaints' => @complaints[:average_time],
          'Rules' => @rules[:average_time],
        },
      }
      chart data, height: 175
    end


    bounding_box [bounds.width / 2 + 20, y + 166.75], width: bounds.width / 2 - 30 do
      text "Total Completed in #{@params[:month_name]}\n\n", align: :center
      data = {
          'Total' => {
              'Complaints' => @complaints[:closed].count,
              'Inspections' => @inspections[:completed].count,
              'Rules' => @rules[:approved].count,
          },
      }
      chart data, height: 175
    end
  end

  private

  def bulleted_list(data)
    return '' if data.empty?

    bullet_data = []
    data.each { |d| bullet_data << ["•", d] }

    make_table(
        bullet_data,
        {
          cell_style: {
            borders: [],
            padding: [0, 10, 0, 0],
            size: 7
          },
          width: bounds.width * 0.65 }
    ) do
      column(0).align = :right
      column(0).width = 30
    end
  end

  def complaints_table_data
    table = [
      ["Closed: #{@complaints[:closed].count}"],
      [bulleted_list(@complaints[:closed].map {|c| "##{c.complaint_number} against#{" ##{c.cemetery.cemetery_id}" if c.cemetery} #{c.formatted_cemetery} (received #{c.created_at})"})],
      ["Active: #{@complaints[:active].count}"],
      [bulleted_list(@complaints[:active].map {|c| "##{c.complaint_number} against#{" ##{c.cemetery.cemetery_id}" if c.cemetery} #{c.formatted_cemetery} (received #{c.created_at})"})]
    ]

    if @complaints[:closed].count == 0
      table.delete_at(1)
    else
      table[2] = ["\n#{table[2][0]}"]
    end

    table.delete_at(3) if @complaints[:active].count == 0

    table
  end

  def inspections_table_data
    table = [
      ["Completed: #{@inspections[:completed].count}"],
      [bulleted_list(@inspections[:completed].map {|i| "##{i.cemetery.cemetery_id}: #{i.cemetery.name} (inspected on #{i.date_performed}; completed on #{i.date_mailed})"})],
      ["Incomplete: #{@inspections[:incomplete].count}"],
      ["Overdue: #{@params[:investigator].overdue_inspections.count}"]
    ]

    if @inspections[:completed].count == 0
      table.delete_at(1)
    else
      table[2] = ["\n#{table[2][0]}"]
    end

    table
  end

  def rules_table_data
    [
      ["Approved: #{@rules[:approved].count}"],
      [bulleted_list(@rules[:approved].map {|r| "##{r.cemetery.cemetery_id}: #{r.cemetery.name} (received on #{r.created_at}; approved on #{r.approval_date})"})],
      ["Awaiting Review: #{@rules[:unreviewed].count}"]
    ]
  end
end
