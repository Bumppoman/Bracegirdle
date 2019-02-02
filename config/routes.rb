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
  get 'complaints/unassigned', to: 'complaints#unassigned', as: :unassigned_complaints
  resources :complaints do
    resources :notes, module: :complaints
  end
  patch 'complaints/:id/update-investigation', to: 'complaints#update_investigation', as: :complaint_update_investigation

  # Non-Compliance Notices
  resources :non_compliance_notices do
    resources :notes, module: :non_compliance_notices
  end
  get 'non_compliance_notices/:id/download', to: 'non_compliance_notices#download', as: :download_non_compliance_notice
  patch 'non_compliance_notices/:id/update-parameters', to: 'non_compliance_notices#update_status', as: :non_compliance_notice_update_status


  # Users
  resources :sessions, only: [:new, :create, :destroy]
  get 'login' => 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  root 'dashboard#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
