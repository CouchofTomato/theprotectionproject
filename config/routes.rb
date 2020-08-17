# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'static_pages#home'

  devise_for :users, controllers: { invitations: 'users/invitations' }

  resources :comparisons
  resources :comparison_products, only: %i[index new]
  resources :insurers do
    resources :products
  end
end
