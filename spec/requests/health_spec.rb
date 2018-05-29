# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'health namespace', type: :request do
  describe 'GET /health' do
    it 'redirects to metrics index' do
      get '/health'
      expect(response).to redirect_to('/health/metrics')
    end
  end
end
