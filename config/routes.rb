Rails.application.routes.draw do

  ActiveAdmin.routes(self)
  resources :settings

  resources :appointments

  get 'appointments/by-date/:appt_date' => 'appointments#by_date', :as => 'appointments_by_date'

  get '/calendar' => 'calendar#show'

  get 'reps/show'

  get 'profiles/reset_password/:id' => 'profiles#reset_password', :as => 'reset_user_password'
  resources :profiles

  namespace :profiles do
    namespace :move do
      get  :new
      post :create
    end
  end

  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-password
  # devise_for :users, :skip => [:registrations]

  # https://github.com/plataformatec/devise#configuring-controllers
  devise_for :users, controllers: { sessions: 'users/sessions' }, :skip => [:registrations]

  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    patch 'users/:id' => 'devise/registrations#update', :as => 'user_registration'
  end

  resources :activities do
    get :autocomplete_client_name, :on => :collection
  end

  resources :models

  resources :industries

  resources :clients do
    resources :contacts
  end
  resources :outsiders
  get 'prospects/unassigned' => 'prospects#unassigned'
  get 'prospects/assignedoutsider' => 'prospects#assignedoutsider'
  get 'prospects/assignedrsm' => 'prospects#assignedrsm'
  get 'prospects/assignedcurrentrsm' => 'prospects#assignedcurrentrsm'
  resources :prospects do
    get :autocomplete_outsider_email, :on => :collection
    resources :contacts
    resources :outsiders
    resources :rsms
  end

  get 'prospects/convert_to_client/:id' => 'prospects#convert_to_client', :as => 'convert_prospect_to_client'
  get 'clients/archive/:id' => 'clients#archive', :as => 'archive_client'
  get 'clients/unarchive/:id' => 'clients#un_archive', :as => 'un_archive_client'
  get 'clients-archived' => 'clients#index_archived', :as => 'archived_clients'
  get 'clients/:id/reps/:user_id' => 'clients#show'
  root 'activities#index'
  get 'clients/:id/add-rsm-to-client' => 'clients#add_rsm_to_client', :as => 'add_rsm_to_client'
  get 'clients/:id/remove_rsm_from_client' => 'clients#remove_rsm_from_client', :as => 'remove_rsm_from_client'
  get 'prospects/:id/remove_rsm_from_prospect' => 'prospects#remove_rsm_from_prospect', :as => 'remove_rsm_from_prospect'
  get '/auditlogs' => 'audit_logs#index'

end
