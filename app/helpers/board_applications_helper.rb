module BoardApplicationsHelper
  def board_application_link(board_application, method = :to_sym, title = nil)
    path = board_application_path(board_application, method)

    if board_application.has_attribute? :application_type
      link_to (title.nil? ? board_application : title), self.send(path, board_application, application_type: board_application.application_type)
    else
      link_to (title.nil? ? board_application : title), self.send(path, board_application)
    end
  end
  
  def board_application_path(board_application, method = :to_sym)
    case board_application.status.to_sym
      when :received, :assigned
        "evaluate_board_applications_#{board_application.send(method).downcase}_path"
      when :evaluated
        if current_user.supervisor?
          "review_board_applications_#{board_application.send(method).downcase}_path"
        else
          "board_applications_#{board_application.send(method).downcase}_path"
        end
      when :reviewed, :scheduled, :approved
        "board_applications_#{board_application.send(method).downcase}_path"
    end
  end
end