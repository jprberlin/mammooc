# -*- encoding : utf-8 -*-
Rails.application.routes.draw do
  get 'api_connection/index'
  get 'api_connection/send_request'
  get 'api_connection/update_user'
  get 'api_connection/update_all_users'

  devise_for :users, skip: [:registrations], controllers: {registrations: 'users/registrations',
                                                           sessions: 'users/sessions',
                                                           passwords: 'users/passwords',
                                                           omniauth_callbacks: 'users/omniauth_callbacks'}
  as :user do
    get '/users/cancel' => 'users/registrations#cancel', :as => 'cancel_user_registration'
    post '/users' => 'users/registrations#create', :as => 'user_registration'
    get '/users/sign_up' => 'users/registrations#new', :as => 'new_user_registration'
    patch '/users' => 'users/registrations#update'
    put '/users' => 'users/registrations#update'
    delete '/users' => 'users/registrations#destroy'
    match '/users/finish_signup' => 'users/registrations#finish_signup', via: [:get, :patch], :as => :finish_signup
    match '/users/auth/easyID' => 'users/omniauth_callbacks#easy_id', via: [:get, :post], :as => :easy_id
    get '/users/deauth/:provider' => 'users/omniauth_callbacks#deauthorize', as: :omniauth_deauthorize
  end

  resources :user_assignments

  resources :course_assignments

  resources :bookmarks, except: [:edit, :new, :show, :update, :destroy]

  resources :progresses

  resources :approvals

  resources :course_requests

  resources :user_groups

  resources :comments

  resources :recommendations, except: [:edit, :show, :update, :destroy]

  resources :statistics

  resources :groups

  resources :course_results

  resources :mooc_providers

  resources :users, except: [:new, :create, :index, :edit]

  get 'dashboard/dashboard'

  get 'home/index'
  get 'about' => 'static_pages#about'
  get 'dashboard' => 'dashboard#dashboard'

  # Evaluations
  post 'evaluations/:id/process_feedback' => 'evaluations#process_feedback'

  # Groups
  get 'groups_where_user_is_admin' => 'groups#groups_where_user_is_admin'
  post 'groups/:id/invite_members' => 'groups#invite_group_members'
  post 'groups/:id/add_administrator' => 'groups#add_administrator'
  post 'groups/:id/demote_administrator' => 'groups#demote_administrator'
  post 'groups/:id/remove_group_member' => 'groups#remove_group_member'
  post 'groups/:id/condition_for_changing_member_status' => 'groups#condition_for_changing_member_status'
  post 'groups/:id/leave' => 'groups#leave'
  get 'groups/join/:token' => 'groups#join'
  get 'groups/:id/members' => 'groups#members'
  get 'groups/:id/recommendations' => 'groups#recommendations'
  get 'groups/:id/statistics' => 'groups#statistics'
  get 'groups/:id/all_members_to_administrators' => 'groups#all_members_to_administrators'
  get 'groups/:id/synchronize_courses' => 'groups#synchronize_courses'

  # Recommendations
  get 'recommendations/:id/delete_user_from_recommendation' => 'recommendations#delete_user_from_recommendation'
  get 'recommendations/:id/delete_group_recommendation' => 'recommendations#delete_group_recommendation'
  root to: 'home#index'

  # Activities
  get 'activities/:id/delete_group_from_newsfeed_entry' => 'activities#delete_group_from_newsfeed_entry'
  get 'activities/:id/delete_user_from_newsfeed_entry' => 'activities#delete_user_from_newsfeed_entry'

  # Courses
  post 'courses/:id/send_evaluation' => 'courses#send_evaluation'
  get 'courses' => 'courses#index'
  get 'courses/index'
  get 'courses/load_more' => 'courses#load_more'
  get 'courses/filter_options' => 'courses#filter_options'
  get 'courses/search' => 'courses#search'
  get 'courses/autocomplete' => 'courses#autocomplete'
  get 'courses/:id' => 'courses#show', as: 'course'
  get 'courses/:id/enroll_course' => 'courses#enroll_course'
  get 'courses/:id/unenroll_course' => 'courses#unenroll_course'

  # Bookmarks
  post 'bookmarks/delete' => 'bookmarks#delete'

  # Users
  get 'users/:id/synchronize_courses' => 'users#synchronize_courses', as: 'synchronize_courses'
  get 'users/:id/settings' => 'users#settings', as: 'user_settings'
  post 'users/:id/set_setting' => 'users#set_setting'
  get 'users/:id/account_settings' => 'users#account_settings'
  get 'users/:id/mooc_provider_settings' => 'users#mooc_provider_settings'
  get 'users/:id/privacy_settings' => 'users#privacy_settings'
  get 'users/:id/set_mooc_provider_connection' => 'users#set_mooc_provider_connection'
  get 'users/:id/revoke_mooc_provider_connection' => 'users#revoke_mooc_provider_connection'
  patch 'users/:id/change_email' => 'users#change_email', as: 'change_email'
  get 'users/:id/cancel_change_email' => 'users#cancel_change_email'
  get 'users/:id/connected_users_autocomplete' => 'users#connected_users_autocomplete'
  get 'users/:id/completions' => 'users#completions', as: 'completions'

  # UserEmails
  get 'user_emails/:id/mark_as_deleted' => 'user_emails#mark_as_deleted'

  # OAuth
  get 'oauth/callback' => 'users#oauth_callback'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
