module TrusteesHelper
  def trustees_for_select(cemetery, value = :id, selected = nil)
    options_for_select(
      cemetery.trustees.order(:position, :name).map { |t| [t.name, t.send(value), { 'data-position' => t.position }] }, selected)
  end

  def trustees_with_full_data_for_select(cemetery, selected = nil)
    trustees = cemetery.trustees.order(:position, :name).map do |t|
      [t.name, t.name, {
          'data-position' => t.position,
          'data-street-address' => t.street_address,
          'data-city' => t.city,
          'data-state' => t.state,
          'data-zip' => t.zip,
          'data-phone' => t.phone,
          'data-email' => t.email
      }]
    end

    options_for_select(trustees, selected)
  end
end