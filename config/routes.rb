# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#home'

  devise_for :users, controllers: { invitations: 'users/invitations' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
