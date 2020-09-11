# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'static_pages#home'

  devise_for :users, controllers: { invitations: 'users/invitations' }

  get '/comparisons/show', to: 'comparisons#show'

  resources :comparisons, only: %i[new]
  resources :comparison_products, only: %i[new create]

  resources :insurers do
    resources :products, only: [:index]
  end

  resources :products do
    resources :product_modules, only: %i[index]
  end
end
