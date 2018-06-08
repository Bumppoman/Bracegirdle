Rails.application.routes.draw do
  get 'dashboard/index'

  # Cemeteries
  get 'cemeteries/region/:region' => 'cemeteries#list_by_region'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
