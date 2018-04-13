# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Foi::SubmissionsController, type: :controller do
  let(:foi_request) { build_stubbed(:foi_request) }

  before do
    scope = double
    allow(FoiRequest).to receive(:includes).with(:contact).and_return(scope)
    allow(scope).to receive(:references).with(:contact).and_return(scope)
    allow(scope).to receive(:find).with('1').and_return(foi_request)
  end

  describe 'GET #new' do
    subject { get :new, params: { request_id: '1' } }

    it 'returns http success' do
      is_expected.to have_http_status(200)
    end
  end

  describe 'POST #create' do
    subject { post :create, params: { request_id: '1' } }

    it 'redirects to foi_request sent' do
      is_expected.to redirect_to(foi_request_sent_path(foi_request))
    end
  end

  describe 'GET #show' do
    subject { get :show, params: { request_id: '1' } }

    it 'returns http success' do
      is_expected.to have_http_status(200)
    end
  end
end
