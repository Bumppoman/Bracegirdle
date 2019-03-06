Rails.application.routes.draw do
  get 'estimates/new'
  get 'dashboard/index'

  # Cemeteries
  resources :cemeteries do
    resources :trustees
  end
  get 'cemeteries/:id/complaints', to: 'cemeteries#show', defaults: { tab: :complaints }, as: :cemetery_complaints
  get 'cemeteries/county/:county', to: 'cemeteries#list_by_county', as: :cemeteries_by_county
  get 'cemeteries/county/:county/options', to: 'cemeteries#options_for_county'
  get 'cemeteries/region/:region' => 'cemeteries#list_by_region'
  get 'cemeteries/:id/rules', to: 'rules#show_approved', as: :cemetery_rules
  get 'cemeteries/:id/details.json', to: 'cemeteries#as_json', as: :cemetery_json
  get 'cemeteries/:id/trustees/api/list', to: 'trustees#api_list', as: :trustees_api_list

  # Complaints
  get 'complaints/unassigned', to: 'complaints#unassigned', as: :unassigned_complaints
  get 'complaints/pending-closure', to: 'complaints#pending_closure', as: :complaints_pending_closure
  get 'complaints/all', to: 'complaints#all', as: :all_complaints
  resources :complaints do
    resources :attachments, module: :complaints
    resources :notes, module: :complaints
  end
  get 'complaints/:id/investigation-details', to: 'complaints#show', defaults: { tab: :investigation }, as: :complaint_investigation
  patch 'complaints/:id/update-investigation', to: 'complaints#update_investigation', as: :complaint_update_investigation

  # Dashboard
  post 'dashboard/search', to: 'dashboard#search', as: :search
  root 'dashboard#index'

  # Errors
  get '/403', to: 'errors#forbidden'
  get '/500', to: 'errors#internal_server_error'

  # Notices
  resources :notices do
    resources :notes, module: :notices
    member do
      get '*filename.pdf', to: 'notices#download', as: :download
      patch 'update-status', to: 'notices#update_status'
    end
  end

  # Notifications
  patch 'notifications/:id/mark-read', to: 'notifications#mark_read', as: :read_notification

  # PDFs
  mount PdfjsViewer::Rails::Engine => "/pdfjs", as: 'pdfjs'

  # Restoration
  restoration_type = Regexp.new([:abandonment, :hazardous, :vandalism].join("|"))
  resources :restoration, path: ':type', constraints: { type: restoration_type } do
    resources :estimates
    resources :notes, module: :restoration
    collection do
      get 'unreviewed', to: 'restoration#unreviewed', as: :unreviewed
    end

    member do
      patch 'finish-processing', to: 'restoration#finish_processing', as: :finish_processing
      patch 'upload-application', to: 'restoration#upload_application', as: :upload_application
      patch 'upload-legal-notice', to: 'restoration#upload_legal_notice', as: :upload_legal_notice
      patch 'upload-previous', to: 'restoration#upload_previous', as: :upload_previous
      get 'process', to: 'restoration#process_restoration', as: :process
      get 'review', to: 'restoration#review', as: :review
      get 'view-application-form', to: 'restoration#view_application_form', as: :view_application_form
      get 'view-legal-notice', to: 'restoration#view_legal_notice', as: :view_legal_notice
      get 'view-previous-report', to: 'restoration#view_previous_report', as: :view_previous_report
      get 'view-raw-application', to: 'restoration#view_raw_application', as: :view_raw_application
      get 'view-report', to: 'restoration#view_report', as: :view_report
    end
  end

  # Rules
  get 'rules/upload-old-rules', to: 'rules#upload_old_rules', as: :upload_old_rules
  post 'rules/upload-old-rules', to: 'rules#create_old_rules', as: :create_old_rules
  resources :rules do
    resources :notes, module: :rules
    member do
      get '*filename.pdf', to: 'rules#download_approval', as: :download_approval
      patch 'review', to: 'rules#review'
      patch 'upload-revision', to: 'rules#upload_revision'
    end
  end

  # Towns
  get 'towns/county/:county/options', to: 'towns#options_for_county'

  # Users
  resources :sessions, only: [:new, :create, :destroy]
  get 'login' => 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
