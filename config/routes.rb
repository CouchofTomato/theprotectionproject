# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'static_pages#home'

  devise_for :users, controllers: { invitations: 'users/invitations' }

  get '/comparisons/show', to: 'comparisons#show'

  # comparisons are used to manually choose which insurer, product and
  # product_module options to add to the comparison table
  resources :comparisons, only: %i[new]

  # suitable plans match user provided responses to plans that meet the
  # criteria
  resources :suitable_plans, only: %i[new create]
end
