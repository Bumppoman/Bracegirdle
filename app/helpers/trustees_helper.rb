module TrusteesHelper
  def trustees_for_select(cemetery)
    options_for_select(
        cemetery.trustees.map{ |t| ["#{t.name} (#{t.position_name})", t.id] })
  end
end