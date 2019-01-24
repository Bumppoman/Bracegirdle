Rails.application.routes.draw do
  get 'dashboard/index'

  # Cemeteries
  resources :cemeteries
  get 'cemeteries/:id/trustees', to: 'cemeteries#show', defaults: { tab: :trustees }, as: :cemetery_trustees
  post 'cemeteries/:id/trustees/new' => 'cemeteries#create_new_trustee', as: :create_new_trustee
  get 'cemeteries/:id/trustees/new' => 'cemeteries#new_trustee', as: :new_trustee
  get 'cemeteries/:id/trustees/:trustee/edit' => 'cemeteries#edit_trustee', as: :edit_trustee
  patch 'cemeteries/:id/trustees/:trustee/edit' => 'cemeteries#update_trustee'
  get 'cemeteries/county/:county' => 'cemeteries#list_by_county'
  get 'cemeteries/region/:region' => 'cemeteries#list_by_region'

  # Complaints
  resources :complaints

  # Non-Compliance Notices
  resources :non_compliance_notices
  get 'non_compliance_notices/:id/download', to: 'non_compliance_notices#download', as: :download_non_compliance_notice

  # Users
  get 'login' => 'users#login', as: :login

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
