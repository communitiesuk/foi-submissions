# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  root to: redirect('foi')

  namespace :foi do
    root to: 'requests#index'
    resource :request, except: %i[show destroy] do
      root to: redirect('foi/request/new')
      resources :suggestions, only: %i[index]
      get 'contact', to: redirect('foi/request/contact/new')
      resource :contact, except: %i[show destroy]
      get 'preview', to: 'submissions#new', as: 'preview'
      post 'send', to: 'submissions#create', as: 'send'
      get 'sent', to: 'submissions#show', as: 'sent'
    end
  end

  namespace :admin do
    root to: redirect('/admin/curated_links')
    resources :curated_links, except: [:show]
  end

  resolve('FoiRequest') { %i[foi request] }

  mount Sidekiq::Web => '/sidekiq'
end
