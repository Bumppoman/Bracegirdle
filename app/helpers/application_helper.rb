module ApplicationHelper
  def active_item(expression)
    "active" if expression
  end

  def format_date_param(param)
    if param =~ /[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4}/
      return Date.strptime(param, "%m/%d/%Y", )
    else
      return Date.parse(param) rescue nil
    end
  end
end
