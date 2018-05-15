# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::CuratedLinksController, type: :controller do
  let(:curated_link) { build_stubbed(:curated_link) }
  let(:valid_params) { { title: 'Title', url: 'https://www.example.com' } }
  let(:invalid_params) { { invalid: true } }

  describe 'GET #index' do
    subject { get :index }

    it 'returns http success' do
      is_expected.to have_http_status(200)
    end
  end

  describe 'GET #new' do
    subject { get :new }

    it 'returns http success' do
      is_expected.to have_http_status(200)
    end
  end

  describe 'POST #create' do
    before { allow(CuratedLink).to receive(:new).and_return(curated_link) }

    context 'valid parameters' do
      subject { post :create, params: { curated_link: valid_params } }
      before { allow(curated_link).to receive(:update).and_return(true) }

      it 'receives valid attributes' do
        expect(curated_link).to receive(:update).
          with(ActionController::Parameters.new(valid_params).permit!)
        subject
      end

      it 'redirects to edit' do
        is_expected.to redirect_to(edit_admin_curated_link_path(curated_link))
      end
    end

    context 'invalid parameters' do
      subject { post :create, params: { curated_link: invalid_params } }
      before { allow(curated_link).to receive(:update).and_return(false) }

      it 'returns http success' do
        is_expected.to have_http_status(200)
      end
    end
  end

  describe 'GET #edit' do
    subject { get :edit, params: { id: 1 } }
    before do
      allow(CuratedLink).to receive(:find).with('1').and_return(curated_link)
    end

    it 'returns http success' do
      is_expected.to have_http_status(200)
    end
  end

  describe 'PUT #update' do
    before do
      allow(CuratedLink).to receive(:find).with('1').and_return(curated_link)
    end

    context 'valid parameters' do
      subject { put :update, params: { id: '1', curated_link: valid_params } }
      before { allow(curated_link).to receive(:update).and_return(true) }

      it 'receives valid attributes' do
        expect(curated_link).to receive(:update).
          with(ActionController::Parameters.new(valid_params).permit!)
        subject
      end

      it 'redirects to edit' do
        is_expected.to redirect_to(edit_admin_curated_link_path(curated_link))
      end
    end

    context 'invalid parameters' do
      subject { put :update, params: { id: '1', curated_link: invalid_params } }
      before { allow(curated_link).to receive(:update).and_return(false) }

      it 'returns http success' do
        is_expected.to have_http_status(200)
      end
    end
  end
end
