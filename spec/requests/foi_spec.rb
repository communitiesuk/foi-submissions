# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'foi namespace', type: :request do
  describe 'GET /' do
    it 'redirects to foi namespace' do
      get '/'
      expect(response).to redirect_to('/foi')
    end
  end

  describe 'GET /foi/request' do
    it 'redirects to new request' do
      get '/foi/request'
      expect(response).to redirect_to('/foi/request/new')
    end
  end

  describe 'GET /foi/request/contact' do
    it 'redirects to new contact' do
      get '/foi/request/contact'
      expect(response).to redirect_to('/foi/request/contact/new')
    end
  end
end
