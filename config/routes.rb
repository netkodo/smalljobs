require 'main_subdomain'
require 'region_subdomain'

Smalljobs::Application.routes.draw do

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :brokers, only: :confirmations, controllers: {
    confirmations: 'confirmations'
  }

  devise_for :providers, only: :confirmation, controllers: {
    confirmations: 'confirmations'
  }

  devise_for :seekers, only: :confirmation, controllers: {
    confirmations: 'confirmations'
  }

  get 'about_us',         to: 'pages#about_us'
  get 'privacy_policy',   to: 'pages#privacy_policy'
  get 'terms_of_service', to: 'pages#terms_of_service'
  get 'features',         to: 'pages#features'
  get 'join_us',          to: 'pages#join_us'
  get 'rules_of_action',  to: 'pages#rules_of_action'

  constraints(RegionSubdomain) do
    devise_for :brokers, except: :confirmation, controllers: {
      registrations: 'registrations',
      sessions: 'sessions'
    }

    devise_for :providers, except: :confirmation, controllers: {
      registrations: 'registrations',
      sessions: 'sessions'
    }

    devise_for :seekers, except: :confirmation, controllers: {
      registrations: 'registrations',
      sessions: 'sessions'
    }

    get 'sign_in', to: 'pages#sign_in'
    get 'sign_up', to: 'pages#sign_up'

    namespace :broker do
      resource :dashboard, only: :show
      resource :organization, only: [:edit, :update]

      resources :providers
      resources :seekers

      resources :jobs do
        member do
          post 'activate'
        end

        resources :allocations, except: :show
      end
    end

    namespace :provider do
      resource :dashboard, only: :show

      resources :jobs do
        resources :allocations, only: [:index, :show]
      end
    end

    namespace :seeker do
      resource :dashboard, only: :show

      resources :jobs, only: [:index, :show] do
        # resources :allocations, only: [:index, :show]
        resources :allocations
      end
    end

    resources :jobs, only: :show



    get '/' => 'regions#show'
  end


  #API
  post '/api/users/login' => 'api#login'
  get '/api/users/logout' => 'api#logout'
  post '/api/users/register' => 'api#register'
  get '/api/users' => 'api#list_users'
  get '/api/users/:id' => 'api#show_user'
  patch '/api/users/:id' => 'api#update_user'
  get '/api/market/regions' => 'api#list_regions'
  get '/api/market/:region/organizations' => 'api#list_organizations'
  get '/api/jobs' => 'api#list_jobs'
  post '/api/jobs/apply' => 'api#apply'
  get '/api/jobs/:id/revoke' => 'api#revoke'
  get '/api/jobs/:id' => 'api#show_job'
  get '/api/jobs/user/:id' => 'api#list_my_jobs'
  post '/api/assignments' => 'api#create_allocation'
  patch '/api/assignments/:id' => 'api#update_allocation'
  delete '/api/assignments/:id' => 'api#delete_allocation'
  get '/api/assignments' => 'api#list_allocations'
  get '/api/assignments/:id' => 'api#show_allocation'


  root 'regions#index'
end
