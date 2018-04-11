# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'foi namespace', type: :request do
  describe 'GET /' do
    it 'redirects to requests index' do
      get '/'
      expect(response).to redirect_to('/foi/requests')
    end
  end

  describe 'GET /foi' do
    it 'redirects to requests index' do
      get '/foi'
      expect(response).to redirect_to('/foi/requests')
    end
  end
end
