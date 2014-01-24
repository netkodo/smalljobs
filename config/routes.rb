require 'main_subdomain'
require 'region_subdomain'

Smalljobs::Application.routes.draw do

  constraints(MainSubdomain) do
    devise_for :admins

    get 'about_us',         to: 'pages#about_us'
    get 'privacy_policy',   to: 'pages#privacy_policy'
    get 'terms_of_service', to: 'pages#terms_of_service'
    get 'features',         to: 'pages#features'
    get 'join_us',          to: 'pages#join_us'
  end

  constraints(RegionSubdomain) do
    devise_for :brokers, controllers: {
      registrations: 'registrations',
      confirmations: 'confirmations'
    }

    devise_for :providers, controllers: {
      registrations: 'registrations',
      confirmations: 'confirmations'
    }

    devise_for :seekers, controllers: {
      registrations:      'registrations',
      confirmations:      'confirmations',
      omniauth_callbacks: 'omniauth_callbacks'
    }

    get 'sign_in', to: 'pages#sign_in'

    namespace :broker do
      resource :dashboard, only: :show
      resources :providers
      resources :seekers
      resources :jobs
    end

    namespace :provider do
      resource :dashboard, only: :show
    end

    namespace :seeker do
      resource :dashboard, only: :show
    end

    get '/' => 'regions#show'
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root 'regions#index'
end
