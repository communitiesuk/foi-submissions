# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HTTP auth', type: :request do
  describe 'GET /' do
    before { ENV['HTTP_AUTH_PASSWORD'] = 'password' }

    it 'return 401 if not authorised' do
      get '/foi/requests'
      expect(response).to have_http_status(401)
    end

    it 'reject incorrect password' do
      auth = ActionController::HttpAuthentication::Basic.encode_credentials(
        'hackney-foi', 'invalid'
      )
      get '/foi/requests', headers: { 'HTTP_AUTHORIZATION' => auth }
      expect(response).to have_http_status(401)
    end

    it 'allows through to action with correct password' do
      auth = ActionController::HttpAuthentication::Basic.encode_credentials(
        'hackney-foi', 'password'
      )
      get '/foi/requests', headers: { 'HTTP_AUTHORIZATION' => auth }
      expect(response).to have_http_status(200)
    end
  end
end
