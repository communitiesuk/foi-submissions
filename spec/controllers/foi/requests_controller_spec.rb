# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Foi::RequestsController, type: :controller do
  include_context 'FOI Request Scope'

  let(:foi_request) { build_stubbed(:foi_request) }
  let(:valid_params) { { body: 'A request body' } }
  let(:invalid_params) { { invalid: true } }

  describe 'GET #index' do
    subject { get :index }

    it 'returns http success' do
      is_expected.to have_http_status(200)
    end
  end

  describe 'GET #new' do
    subject { get :new }
    before { allow(FoiRequest).to receive(:new).and_return(foi_request) }

    it 'returns http success' do
      is_expected.to have_http_status(200)
    end
  end

  describe 'POST #create' do
    context 'valid parameters' do
      subject { post :create, params: { foi_request: valid_params } }

      before do
        allow(FoiRequest).to receive(:new).and_return(foi_request)
        allow(foi_request).to receive(:update).and_return(true)
      end

      it 'receives valid attributes' do
        expect(foi_request).to receive(:update).
          with(ActionController::Parameters.new(valid_params).permit!)
        subject
      end

      it 'stores request ID in the session' do
        expect { subject }.to(change { session[:request_id] })
      end

      it 'redirects to suggestions' do
        is_expected.to redirect_to(foi_request_suggestions_path(foi_request))
      end
    end

    context 'invalid parameters' do
      subject { post :create, params: { foi_request: invalid_params } }

      before do
        allow(FoiRequest).to receive(:new).and_return(foi_request)
        allow(foi_request).to receive(:update).and_return(false)
      end

      it 'returns http success' do
        is_expected.to have_http_status(200)
      end
    end
  end

  describe 'GET #edit' do
    subject { get :edit, params: { request_id: '1' } }

    before do
      allow(FoiRequest).to receive(:find).with('1').and_return(foi_request)
    end

    it 'returns http success' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT #update' do
    before do
      allow(foi_request_scope).to receive(:find_by).
        with(id: '1').and_return(foi_request)
    end

    context 'valid parameters' do
      subject do
        put :update, params: { request_id: '1', foi_request: valid_params }
      end
      before { allow(foi_request).to receive(:update).and_return(true) }

      it 'receives valid attributes' do
        expect(foi_request).to receive(:update).
          with(ActionController::Parameters.new(valid_params).permit!)
        subject
      end

      it 'redirects to suggestions' do
        is_expected.to redirect_to(foi_request_suggestions_path(foi_request))
      end
    end

    context 'invalid parameters' do
      subject do
        put :update, params: { request_id: '1', foi_request: invalid_params }
      end
      before { allow(foi_request).to receive(:update).and_return(false) }

      it 'returns http success' do
        is_expected.to have_http_status(200)
      end
    end
  end
end
