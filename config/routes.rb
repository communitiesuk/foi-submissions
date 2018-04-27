# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect('foi')

  namespace :foi do
    root to: 'requests#index'
    resources :requests, except: %i[show destroy] do
      root to: redirect('foi/request/new')
      resources :suggestions, only: %i[index]
      get 'contact', to: redirect('foi/requests/%{request_id}/contact/new')
      resource :contact, except: %i[show destroy]
      get 'preview', to: 'submissions#new', as: 'preview'
      post 'send', to: 'submissions#create', as: 'send'
      get 'sent', to: 'submissions#show', as: 'sent'
    end
  end
end
