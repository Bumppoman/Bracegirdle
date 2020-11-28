Rails.application.routes.draw do
  get 'dashboard/index'

  # Admin
  namespace :admin do
    get 'letterhead/edit', to: 'letterhead#edit', as: :edit_letterhead
    patch 'letterhead/update', to: 'letterhead#update', as: :update_letterhead
  end
  
  # Appointments
  resources :appointments do
    member do
      patch :begin
      patch :cancel
      patch :reschedule
    end
  end

  # Auth0
  post 'auth/auth0', as: 'authentication'
  get 'auth/auth0/callback', to: 'sessions#callback'
  get 'auth/failure', to: 'sessions#failure'

  # Board applications
  namespace :board_applications do
    resources :land, path: 'land/:application_type', type: /(purchase|sale)/, only: [:create, :new, :index, :show] do
      member do
        get :evaluate
      end
    end

    # Restoration
    def restoration_actions_for(*resources)
      Array(resources).each do |resource|
        self.resources resource do
          self.resources :estimates, module: :restorations
          self.resources :notes, module: :restorations

          member do
            patch 'make-schedulable', to: "#{resource}#make_schedulable"
            patch 'return-to-investigator', to: "#{resource}#return_to_investigator", as: :return_to_investigator
            patch 'send-to-supervisor', to: "#{resource}#send_to_supervisor"
            patch 'upload-application', to: "#{resource}#upload_application", as: :upload_application
            patch 'upload-legal-notice', to: "#{resource}#upload_legal_notice", as: :upload_legal_notice
            patch 'upload-previous', to: "#{resource}#upload_previous", as: :upload_previous
            get 'evaluate', to: "#{resource}#evaluate", as: :evaluate
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

    restoration_actions_for :abandonment, :hazardous, :vandalism
    
    namespace :restorations do
      resources :contractors
    end
  end

  # Board Meetings
  resources :board_meetings do
    member do
      patch 'finalize-agenda'
      get '*filename.pdf', to: 'board_meetings#download_agenda', as: :download_agenda
    end
  end

  # Cemeteries
  resources :cemeteries, param: :cemid do
    resources :trustees, except: :index

    collection do
      get 'county/:county(/:options)', to: 'cemeteries#index_by_county', as: :county
      get 'region/:region', to: 'cemeteries#index_by_region', as: :region
      get 'overdue-inspections(/:type(/:region))', to: 'cemeteries#index_with_overdue_inspections', as: :overdue_inspections
    end

    member do
      get 'complaints', to: 'cemeteries#show', defaults: { tab: :complaints }, as: :complaints
      get 'inspect', to: 'cemetery_inspections#perform', as: :inspect
      get 'inspection/:identifier', to: 'cemetery_inspections#show', as: :show_inspection
      patch 'inspection/:identifier/complete', to: 'cemetery_inspections#complete', as: :complete_inspection
      patch 'inspection/:identifier/finalize', to: 'cemetery_inspections#finalize', as: :finalize_inspection
      patch 'inspection/:identifier/revise', to: 'cemetery_inspections#revise', as: :revise_inspection
      patch 'inspection/:identifier/save', to: 'cemetery_inspections#save', as: :save_inspection
      get 'inspection/:identifier/view-full-package', to: 'cemetery_inspections#view_full_package', as: :view_full_inspection_package
      get 'inspection/:identifier/view-report', to: 'cemetery_inspections#view_report', as: :view_inspection_report
      get 'inspections', to: 'cemeteries#show', defaults: { tab: :inspections }, as: :inspections
      post 'inspections/begin', to: 'cemetery_inspections#begin', as: :begin_inspection
      get 'inspections/upload', to: 'cemetery_inspections#upload', as: :upload_inspection
      post 'inspections/upload', to: 'cemetery_inspections#create', as: :create_inspection
      get 'rules', to: 'rules#show', as: :rules
      get 'rules/:date', to: 'rules#show_for_date', as: :rules_by_date
      get 'trustees', to: 'trustees#index', constraints: -> (req) { req.format == :json }, as: :trustees_list
      get 'trustees', to: 'cemeteries#show', defaults: { tab: :trustees }, as: :trustees
    end
  end
  get 'cemetery/:cemid/details.json', to: 'cemeteries#show', as: :cemetery_json

  # Complaints
  resources :complaints do
    resources :attachments, module: :complaints
    resources :notes, module: :complaints

    collection do
      get :all
      get 'user/:user', to: 'complaints#index_by_user', as: :user
    end

    member do
      patch :assign
      patch :begin_investigation
      patch :close
      patch :complete_investigation
      get :investigation_details, to: 'complaints#show', defaults: { tab: :investigation }, as: :investigation
      patch :reassign
      patch :recommend_closure
      patch :reopen_investigation
      patch :request_update
    end
  end
  
  # Crematories
  namespace :crematories do
    resources :retort_models
  end

  resources :crematories, param: :cemid do
    resources :operators, only: [:create, :show, :update]
    resources :retorts, only: [:create, :show, :update]
  end
  
  # Dashboard
  get 'splash', to: 'dashboard#splash', as: :splash
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
    collection do
      get :schedulable
    end
    
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
      patch :follow_up
      get '*filename.pdf', to: 'notices#download', as: :download
      patch :receive_response
      patch :resolve
    end
  end

  # Notifications
  resources :notifications, only: [] do
    collection do
      patch :mark_all_read
    end
    
    member do
      patch :mark_read
    end
  end

  # PDFs
  mount PdfjsViewer::Rails::Engine => "/pdfjs", as: 'pdfjs'
  
  # Reminders
  resources :reminders do
    member do
      patch :complete
    end
  end

  # Rules
  namespace :rules do
    resources :approvals do
      resources :notes, module: :approvals
      
      resources :revisions do
        patch :receive
      end

      member do
        patch :approve
        patch :assign
        get '*filename.pdf', action: :download_approval_letter, as: :download_approval_letter
        patch :request_revision
        patch :recommend_approval
        patch :upload_revision
        patch :withdraw
      end
    end
  end
  resources :rules

  # Statistics
  get 'statistics/investigator', to: 'statistics#investigator_report'

  # Towns
  get 'towns/county/:county', to: 'towns#index_for_county'

  # Users
  resources :users, only: :none do
    collection do
      get 'team(/:team)', to: 'users#team', as: :team
    end
  end
  get 'user/calendar', to: 'users#calendar', as: :calendar_user
  get 'user/calendar/events', to: 'users#calendar_events', as: :calendar_events_user
  get 'user/change-password', to: 'users#change_password', as: :change_user_password
  get 'user(/:id)/profile', to: 'users#profile', as: :user_profile
  post 'user/update-password', to: 'users#update_password', as: :update_user_password
  get 'logout', to: 'sessions#destroy', as: :logout

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
