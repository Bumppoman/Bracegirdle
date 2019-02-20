module TrusteesHelper
  def trustees_for_select(cemetery)
    options_for_select(
        cemetery.trustees.map{ |t| "#{t.person.name} (#{t.position_name})" })
  end
end