module RestorationHelper
  def restoration_link(restoration, title = nil)
    link_title = (title.nil? ? restoration : title)

    case restoration.status
    when Restoration::STATUSES[:received]
      link_to link_title, process_restoration_path(restoration, type: restoration.application_type)
    when Restoration::STATUSES[:processed], Restoration::STATUSES[:reviewed]
      link_to link_title, restoration_path(restoration, type: restoration.application_type)
    end
  end
end
