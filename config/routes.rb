Rails.application.routes.draw do
  get 'estimates/new'
  get 'dashboard/index'

  # Admin
  namespace :admin do
    get 'letterhead/edit', to: 'letterhead#edit', as: :edit_letterhead
    patch 'letterhead/update', to: 'letterhead#update', as: :update_letterhead
  end

  # Applications
  namespace :applications do
    resources :land, path: 'land/:application_type', type: /(purchase|sale)/, only: [:create, :new, :index, :show] do
      member do
        get 'process', to: 'land#process_application', as: :process
      end
    end

    # Restoration
    def standard_actions_for(*resources)
      Array(resources).each do |resource|
        self.resources resource do
          self.resources :estimates
          self.resources :notes, module: resource

          member do
            patch 'finish-processing', to: "#{resource}#finish_processing", as: :finish_processing
            patch 'return-to-investigator', to: "#{resource}#return_to_investigator", as: :return_to_investigator
            patch 'send-to-board', to: "#{resource}#send_to_board", as: :send_to_board
            patch 'upload-application', to: "#{resource}#upload_application", as: :upload_application
            patch 'upload-legal-notice', to: "#{resource}#upload_legal_notice", as: :upload_legal_notice
            patch 'upload-previous', to: "#{resource}#upload_previous", as: :upload_previous
            get 'process', to: "#{resource}#process_restoration", as: :process
            get 'review', to: "#{resource}#review", as: :review
            get 'view-application-form', to: "#{resource}#view_application_form", as: :view_application_form
            get 'view-combined', to: "#{resource}#view_combined", as: :view_combined
            get 'view-estimate/:estimate', to: "#{resource}#view_estimate", as: :view_estimate
            get 'view-legal-notice', to: "#{resource}#view_legal_notice", as: :view_legal_notice
            get 'view-previous-report', to: "#{resource}#view_previous_report", as: :view_previous_report
            get 'view-raw-application', to: "#{resource}#view_raw_application", as: :view_raw_application
            get 'view-report', to: "#{resource}#view_report", as: :view_report
          end
        end
      end
    end

    standard_actions_for :abandonment, :hazardous, :vandalism

    get 'schedulable', to: 'applications#schedulable'
  end

  # Appointments
  resources :appointments do
    collection do
      get 'api/user-events', to: 'appointments#api_user_events', as: :api_user_events
    end

    member do
      patch :begin
      patch :cancel
      patch :reschedule
    end
  end

  # Auth0
  get 'auth/auth0/callback', to: 'sessions#callback'
  get 'auth/failure', to: 'sessions#failure'

  # Board Meetings
  resources :board_meetings do
    member do
      patch 'finalize-agenda'
      get '*filename.pdf', to: 'board_meetings#download_agenda', as: :download_agenda
    end
  end

  # Cemeteries
  resources :cemeteries, param: :cemetery_id do
    resources :trustees, except: :index do
      member do
        get 'api/show', to: 'trustees#api_show', as: :api_show
      end
    end

    collection do
      get 'county/:county', to: 'cemeteries#list_by_county', as: :county
      get 'county/:county/options', to: 'cemeteries#options_for_county'
      get 'region/:region', to: 'cemeteries#list_by_region', as: :region
      get 'overdue-inspections(/region/:region)', to: 'cemeteries#overdue_inspections', as: :overdue_inspections
    end

    member do
      get 'complaints', to: 'cemeteries#show', defaults: { tab: :complaints }, as: :complaints
      get 'inspect', to: 'cemetery_inspections#perform', as: :inspect
      patch 'inspect/cemetery-information', to: 'cemetery_inspections#cemetery_information', as: :cemetery_information_inspect
      patch 'inspect/physical-characteristics', to: 'cemetery_inspections#physical_characteristics', as: :physical_characteristics_inspect
      patch 'inspect/record-keeping', to: 'cemetery_inspections#record_keeping', as: :record_keeping_inspect
      patch 'inspect/additional-information', to: 'cemetery_inspections#additional_information', as: :additional_information_inspect
      get 'inspection/:identifier', to: 'cemetery_inspections#show', as: :show_inspection
      patch 'inspection/:identifier/finalize', to: 'cemetery_inspections#finalize', as: :finalize_inspection
      patch 'inspection/:identifier/revise', to: 'cemetery_inspections#revise', as: :revise_inspection
      get 'inspection/:identifier/view-full-package', to: 'cemetery_inspections#view_full_package', as: :view_full_inspection_package
      get 'inspection/:identifier/view-report', to: 'cemetery_inspections#view_report', as: :view_inspection_report
      get 'inspections', to: 'cemeteries#show', defaults: { tab: :inspections }, as: :inspections
      post 'inspections/schedule', to: 'cemetery_inspections#schedule', as: :schedule_inspection
      get 'rules', to: 'rules#show', as: :rules
      get 'trustees', to: 'cemeteries#show', defaults: { tab: :trustees }, as: :trustees
      get 'upload-inspection', to: 'cemetery_inspections#upload_old_inspection'
      post 'upload-inspection', to: 'cemetery_inspections#create_old_inspection', as: :create_old_inspection
    end
  end
  get 'cemetery/:id/details.json', to: 'cemeteries#show', as: :cemetery_json
  get 'cemetery/:id/trustees/api/list', to: 'trustees#api_list', as: :trustees_api_list

  # Complaints
  resources :complaints do
    resources :attachments, module: :complaints
    resources :notes, module: :complaints

    collection do
      get :all
      get 'pending-closure'
      get :unassigned
      get 'user/:user', to: 'complaints#index_by_user', as: :user
    end

    member do
      patch :assign
      patch 'begin-investigation'
      patch 'change-investigator'
      patch :close
      patch 'complete-investigation'
      get 'investigation-details', to: 'complaints#show', defaults: { tab: :investigation }
      patch 'reopen-investigation'
      patch 'request-update'
    end
  end

  # Dashboard
  post 'dashboard/search', to: 'dashboard#search', as: :search
  root 'dashboard#index'

  # Errors
  get '/403', to: 'errors#forbidden'
  get '/500', to: 'errors#internal_server_error'

  # Inspections
  resources :cemetery_inspections, only: :none do
    resources :attachments, module: :cemetery_inspections

    collection do
      get :incomplete
      get :scheduled, to: 'appointments#index'
    end
  end

  # Matters
  resources :matters do
    member do
      patch :schedule
      patch :unschedule
    end
  end

  # Notices
  resources :notices do
    resources :attachments, module: :notices
    resources :notes, module: :notices
    member do
      patch 'follow-up'
      get '*filename.pdf', to: 'notices#download', as: :download
      patch :resolve
      patch 'response-received'
    end
  end

  # Notifications
  patch 'notifications/mark-all-read', to: 'notifications#mark_all_read', as: :mark_read_all_notifications
  patch 'notifications/:id/mark-read', to: 'notifications#mark_read', as: :read_notification

  # PDFs
  mount PdfjsViewer::Rails::Engine => "/pdfjs", as: 'pdfjs'

  # Rules
  get 'rules/upload-old-rules', as: :upload_old_rules
  post 'rules/upload-old-rules', to: 'rules#create_old_rules', as: :create_old_rules
  resources :rules do
    resources :notes, module: :rules

    member do
      patch :approve
      patch :assign
      get '*filename.pdf', to: 'rules#download_approval', as: :download_approval
      patch 'request-revision'
      get :review
      patch 'upload-revision'
    end
  end

  # Statistics
  get 'statistics/investigator', to: 'statistics#investigator_report'

  # Towns
  get 'towns/county/:county/options', to: 'towns#options_for_county'

  # Users
  resources :users, only: :none do
    collection do
      get 'team(/:team)', to: 'users#team', as: :team
    end
  end
  get 'user/calendar', to: 'users#calendar', as: :calendar_user
  get 'user/change-password', to: 'users#change_password', as: :change_user_password
  get 'user(/:id)/profile', to: 'users#profile', as: :user_profile
  post 'user/update-password', to: 'users#update_password', as: :update_user_password
  get 'login', to: 'sessions#create', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
