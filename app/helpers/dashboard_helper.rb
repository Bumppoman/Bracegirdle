module DashboardHelper
  def investigator_board_applications
    # Set restorations
    restorations = Restoration.where(investigator: current_user).count
    restorations += Restoration.pending_supervisor_review.count if current_user.supervisor?

    restorations
  end

  def overdue_inspections_by_region
    active_cemeteries = Cemetery.active
    overdue = active_cemeteries
      .where('last_inspection_date < ? OR last_inspection_date IS NULL', Date.current - 5.years)
      .group(:investigator_region)
      .reorder(:investigator_region)
      .count(:id)

    total = active_cemeteries
      .group(:investigator_region)
      .count(:id)

    overdue.map { |region, count| { region: NAMED_REGIONS[region], inspections: count, percentage: (count * 100) / total[region] } }.to_json
  end
end
