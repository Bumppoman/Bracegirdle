module RestorationHelper
  def restoration_link(restoration, title = nil)
    case restoration.status.to_sym
    when :received
      path = "process_#{restoration.type.downcase}_path"
    when :processed
      if current_user.supervisor?
        path = "review_#{restoration.type.downcase}_path"
      else
        path = "#{restoration.type.downcase}_path"
      end
    when :reviewed, :approved
      path = "#{restoration.type.downcase}_path"
    end

    link_to (title.nil? ? restoration : title), self.send(path, restoration)
  end
end
