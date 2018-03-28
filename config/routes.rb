# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect('foi/requests')

  namespace :foi do
    root to: redirect('foi/requests')
    resources :requests, except: %i[show destroy] do
      resources :suggestions, only: %i[index]
      resource :contact, except: %i[show destroy]
      get 'preview', to: 'submissions#new', as: 'preview'
      post 'send', to: 'submissions#create', as: 'send'
      get 'sent', to: 'submissions#show', as: 'sent'
    end
  end
end
