module TrusteesHelper
  def trustees_for_select(cemetery, name_only = false, selected = nil)
    options_for_select(
        cemetery.trustees.order(:position, :name).map { |t| [t.name, name_only ? t.name : t.id, { 'data-position' => t.position }] }, selected)
  end
end