Rails.application.routes.draw do
  get 'estimates/new'
  get 'dashboard/index'

  # Admin
  namespace :admin do
    get 'letterhead/edit', to: 'letterhead#edit', as: :edit_letterhead
    patch 'letterhead/update', to: 'letterhead#update', as: :update_letterhead
  end

  # Auth0
  get 'auth/auth0/callback', to: 'sessions#callback'
  get 'auth/failure', to: 'sessions#failure'

  # Cemeteries
  resources :cemeteries do
    resources :trustees, except: :index do
      member do
        get 'api/show', to: 'trustees#api_show', as: :api_show
      end
    end

    collection do
      get 'overdue-inspections(/region/:region)', to: 'cemeteries#overdue_inspections', as: :overdue_inspections
      get 'api/overdue-inspections-by-region', to: 'cemeteries#api_overdue_inspections_by_region'
    end

    member do
      get 'complaints', to: 'cemeteries#show', defaults: { tab: :complaints }, as: :complaints
      get 'inspect', to: 'cemetery_inspections#perform', as: :inspect
      patch 'inspect/cemetery-information', to: 'cemetery_inspections#cemetery_information', as: :cemetery_information_inspect
      patch 'inspect/physical-characteristics', to: 'cemetery_inspections#physical_characteristics', as: :physical_characteristics_inspect
      patch 'inspect/record-keeping', to: 'cemetery_inspections#record_keeping', as: :record_keeping_inspect
      get 'inspection/:identifier', to: 'cemetery_inspections#show', as: :show_inspection
      patch 'inspection/:identifier/finalize', to: 'cemetery_inspections#finalize', as: :finalize_inspection
      patch 'inspection/:identifier/revise', to: 'cemetery_inspections#revise', as: :revise_inspection
      get 'inspection/:identifier/view-full-package', to: 'cemetery_inspections#view_full_package', as: :view_full_inspection_package
      get 'inspection/:identifier/view-report', to: 'cemetery_inspections#view_report', as: :view_inspection_report
      get 'inspections', to: 'cemeteries#show', defaults: { tab: :inspections }, as: :inspections
      get 'trustees', to: 'cemeteries#show', defaults: { tab: :trustees }, as: :trustees
      get 'upload-inspection', to: 'cemetery_inspections#upload_old_inspection'
      post 'upload-inspection', to: 'cemetery_inspections#create_old_inspection', as: :create_old_inspection
    end
  end
  get 'cemeteries/county/:county', to: 'cemeteries#list_by_county', as: :cemeteries_by_county
  get 'cemeteries/county/:county/options', to: 'cemeteries#options_for_county'
  get 'cemeteries/region/:region' => 'cemeteries#list_by_region', as: :cemeteries_by_region
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

  # Inspections
  get 'inspections/incomplete', to: 'cemetery_inspections#incomplete', as: :incomplete_inspections

  # Notices
  resources :notices do
    resources :attachments, module: :notices
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
  restoration_type = Regexp.new([:abandonment, :hazardous, :vandalism].join('|'))
  resources :restoration, path: ':type', constraints: { type: restoration_type } do
    resources :estimates
    resources :notes, module: :restoration

    member do
      patch 'finish-processing', to: 'restoration#finish_processing', as: :finish_processing
      patch 'return-to-investigator', to: 'restoration#return_to_investigator', as: :return_to_investigator
      patch 'send-to-board', to: 'restoration#send_to_board', as: :send_to_board
      patch 'upload-application', to: 'restoration#upload_application', as: :upload_application
      patch 'upload-legal-notice', to: 'restoration#upload_legal_notice', as: :upload_legal_notice
      patch 'upload-previous', to: 'restoration#upload_previous', as: :upload_previous
      get 'process', to: 'restoration#process_restoration', as: :process
      get 'review', to: 'restoration#review', as: :review
      get 'view-application-form', to: 'restoration#view_application_form', as: :view_application_form
      get 'view-combined', to: 'restoration#view_combined', as: :view_combined
      get 'view-estimate/:estimate', to: 'restoration#view_estimate', as: :view_estimate
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

  # Statistics
  get 'statistics/investigator', to: 'statistics#investigator_report'

  # Towns
  get 'towns/county/:county/options', to: 'towns#options_for_county'

  # Users
  get 'login', to: redirect('/auth/auth0')
  get 'logout', to: 'sessions#destroy', as: :logout

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
