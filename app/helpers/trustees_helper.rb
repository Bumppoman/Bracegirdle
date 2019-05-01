module TrusteesHelper
  def trustee_options(cemetery, selected = nil)
    options_for_select(
      cemetery.trustees.map{ |t| [t.name, t.name, { 'data-position' => t.position }] }, selected)
  end

  def trustees_for_select(cemetery)
    options_for_select(
        cemetery.trustees.map{ |t| [t.name, t.id, { 'data-position' => t.position }] })
  end
end