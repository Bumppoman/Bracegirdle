module RetortModelsHelper
  def retort_model_options(retort_models, selected = nil)
    option_groups_from_collection_for_select RetortModel::MANUFACTURERS,
      -> (manufacturer) { retort_models.where(manufacturer: manufacturer[0]) },
      :last,
      :id,
      :name,
      selected
  end
end
