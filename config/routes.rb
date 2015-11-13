Rails.application.routes.draw do

  resources :settings

  resources :appointments

  get 'appointments/by-date/:appt_date' => 'appointments#by_date'

  get '/calendar' => 'calendar#show'

  get 'reps/show'

  get 'profiles/reset_password/:id' => 'profiles#reset_password', :as => 'reset_user_password'
  resources :profiles

  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-password
  devise_for :users, :skip => [:registrations]
    as :user do
      get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
      patch 'users/:id' => 'devise/registrations#update', :as => 'user_registration'
    end

  resources :activities

  resources :models

  resources :industries

  resources :clients do
    resources :contacts
  end
  resources :prospects do
    resources :contacts
  end
  get 'prospects/convert_to_client/:id' => 'prospects#convert_to_client', :as => 'convert_prospect_to_client'
  get 'clients/archive/:id' => 'clients#archive', :as => 'archive_client'
  get 'clients/unarchive/:id' => 'clients#un_archive', :as => 'un_archive_client'
  get 'clients-archived' => 'clients#index_archived', :as => 'archived_clients'

  get 'clients/:id/reps/:user_id' => 'clients#show'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'activities#index'

  get 'clients/:id/add-rsm-to-client' => 'clients#add_rsm_to_client', :as => 'add_rsm_to_client'
  get 'clients/:id/remove_rsm_from_client' => 'clients#remove_rsm_from_client', :as => 'remove_rsm_from_client'
  get 'prospects/:id/add-rsm-to-prospect' => 'prospects#add_rsm_to_prospect', :as => 'add_rsm_to_prospect'
  get 'prospects/:id/remove_rsm_from_prospect' => 'prospects#remove_rsm_from_prospect', :as => 'remove_rsm_from_prospect'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
