# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'foi namespace', type: :request do
  describe 'GET /' do
    it 'redirects to foi namespace' do
      get '/'
      expect(response).to redirect_to('/foi')
    end
  end

  describe 'GET /foi/requests' do
    it 'redirects to new request' do
      get '/foi/requests'
      expect(response).to redirect_to('/foi/request/new')
    end
  end

  describe 'GET /foi/requests/:id/contact' do
    it 'redirects to new request contact' do
      get '/foi/requests/1/contact'
      expect(response).to redirect_to('/foi/requests/1/contact/new')
    end
  end
end
