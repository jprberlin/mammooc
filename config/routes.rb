# frozen_string_literal: true

# The priority is based upon order of creation: first created -> highest priority.
# See how all your routes lay out with "rails routes".

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
    get '/users/cancel_add_identity' => 'users/sessions#cancel_add_identity', :as => 'cancel_add_identity'
    patch '/users' => 'users/registrations#update'
    put '/users' => 'users/registrations#update'
    delete '/users' => 'users/registrations#destroy'
    get '/users/finish_signup' => 'users/registrations#finish_signup', :as => :finish_signup
    match '/users/auth/easyID' => 'users/omniauth_callbacks#easy_id', via: %i[get post], :as => :easy_id
    get '/users/deauth/:provider' => 'users/omniauth_callbacks#deauthorize', as: :omniauth_deauthorize
    get 'users/login_and_subscribe_to_newsletter' => 'users#login_and_subscribe_to_newsletter'
  end

  resources :bookmarks, except: %i[edit new show update destroy]

  resources :recommendations, except: %i[edit show update destroy]

  resources :groups

  resources :mooc_providers

  resources :users, except: %i[new create index edit]

  resources :user_dates, except: %i[new create edit show update destroy]

  get 'dashboard/dashboard'

  get 'home/index'
  get 'about' => 'static_pages#about'
  get 'dashboard' => 'dashboard#dashboard'

  # Evaluations
  get 'evaluations/export_overall_course_rating' => 'evaluations#export_overall_course_rating', defaults: {format: 'json'}
  get 'evaluations/export_course_evaluations' => 'evaluations#export_course_evaluations', defaults: {format: 'json'}

  get 'evaluations/save' => 'evaluations#save', defaults: {format: 'json'}
  post 'evaluations/login_and_save' => 'evaluations#login_and_save', as: 'load_and_save_evaluation'
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
  get 'users/:id/newsletter_settings' => 'users#newsletter_settings'
  get 'users/:id/set_mooc_provider_connection' => 'users#set_mooc_provider_connection'
  get 'users/:id/revoke_mooc_provider_connection' => 'users#revoke_mooc_provider_connection'
  patch 'users/:id/change_email' => 'users#change_email', as: 'change_email'
  patch 'users/:id/change_newsletter_settings' => 'users#change_newsletter_settings', as: 'change_newsletter_settings'
  get 'users/:id/unsubscribe_newsletter' => 'users#unsubscribe_newsletter', as: 'unsubscribe_newsletter'
  get 'users/:id/cancel_change_email' => 'users#cancel_change_email'
  get 'users/:id/connected_users_autocomplete' => 'users#connected_users_autocomplete'
  get 'users/:id/completions' => 'users#completions', as: 'completions'

  # UserDates
  get 'user_dates/synchronize_dates_on_dashboard' => 'user_dates#synchronize_dates_on_dashboard'
  get 'user_dates/synchronize_dates_on_index_page' => 'user_dates#synchronize_dates_on_index_page'
  get 'user_dates/calendar_feed' => 'user_dates#create_calendar_feed'
  get 'user_dates/my_dates/:token' => 'user_dates#my_dates'
  get 'user_dates/events_for_calendar_view' => 'user_dates#events_for_calendar_view'

  # UserEmails
  get 'user_emails/:id/mark_as_deleted' => 'user_emails#mark_as_deleted'

  # OAuth
  get 'oauth/callback' => 'users#oauth_callback'

  # API
  get 'api/current_user_with_evaluation' => 'apis#current_user_with_evaluation', defaults: {format: 'json'}

  # JSON API
  namespace :api do
    namespace :v1 do
      # Don't forget to add `immutable` to the resources!
      jsonapi_resources :courses
      jsonapi_resources :mooc_providers
      jsonapi_resources :organisation
      jsonapi_resources :course_tracks
      jsonapi_resources :course_track_types
    end
  end
end
