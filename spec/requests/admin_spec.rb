# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'foi namespace', type: :request do
  describe 'GET /admin' do
    it 'redirects to curated links' do
      get '/admin'
      expect(response).to redirect_to('/admin/curated_links')
    end
  end
end
