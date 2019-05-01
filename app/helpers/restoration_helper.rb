module RestorationHelper
  def restoration_link(restoration, title = nil)
    case restoration.status
    when Restoration::STATUSES[:received]
      path = :process_restoration_path
    when Restoration::STATUSES[:processed]
      if current_user.supervisor?
        path = :review_restoration_path
      else
        path = :restoration_path
      end
    when Restoration::STATUSES[:reviewed], Restoration::STATUSES[:approved]
      path = :restoration_path
    end

    link_to (title.nil? ? restoration : title), self.send(path, restoration, type: restoration.application_type)
  end
end
