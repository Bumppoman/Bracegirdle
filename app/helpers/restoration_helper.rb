module RestorationHelper
  def restoration_link(restoration, title = nil)
    case restoration.status.to_sym
    when :received
      path = :process_restoration_path
    when :processed
      if current_user.supervisor?
        path = :review_restoration_path
      else
        path = :restoration_path
      end
    when :reviewed, :approved
      path = :restoration_path
    end

    link_to (title.nil? ? restoration : title), self.send(path, restoration, type: restoration.application_type)
  end
end
