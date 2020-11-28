module DashboardHelper
  def investigator_board_applications
    applications = 0

    # Set restorations
    applications += Restoration.where(investigator: current_user).count
    applications += Restoration.pending_supervisor_review.count if current_user.supervisor?

    # Add land applications
    applications += Land.active_for(current_user).count
    applications += Land.pending_supervisor_review.count if current_user.supervisor?

    applications
  end

  def investigator_inbox_items
    current_user.rules_approvals.where.not(status: :revision_requested).count
  end

  def overdue_inspections_by_region
    active_cemeteries = Cemetery.active
    overdue = active_cemeteries
      .where('last_inspection_date < ? OR last_inspection_date IS NULL', Date.current - 5.years)
      .group(:investigator_region)
      .reorder(:investigator_region)
      .count(:cemid)

    total = active_cemeteries
      .group(:investigator_region)
      .reorder(:investigator_region)
      .count(:cemid)

    {
      labels: NAMED_REGIONS.values,
      inspections: 
        NAMED_REGIONS.keys.map { |region_key|
          overdue.find(-> {[0]}) { |region, count| region === region_key }.last
        },
      percentages:
        NAMED_REGIONS.keys.map { |region_key|
          begin
            (overdue.find(-> {[0]}) { |region, count| region === region_key }.last * 100) / total.fetch(region_key, 0)
          rescue ZeroDivisionError
            0
          end
        }
    }.to_json
  end
end
