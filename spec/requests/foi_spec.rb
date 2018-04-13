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

  describe 'GET /foi/request/:id/contact' do
    include_context 'FOI Request Scope'

    let(:foi_request) { build_stubbed(:foi_request, contact: nil) }

    before do
      allow(foi_request_scope).to receive(:find_by).
        with(id: '1').and_return(foi_request)
    end

    it 'redirects to requests index' do
      get '/foi/requests/1/contact'
      expect(response).to redirect_to('/foi/requests/1/contact/new')
    end
  end
end
