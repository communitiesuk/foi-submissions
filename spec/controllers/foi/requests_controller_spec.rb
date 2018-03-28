# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Foi::RequestsController, type: :controller do
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
    subject { post :create }

    it 'returns http success' do
      is_expected.to have_http_status(204)
    end
  end

  describe 'GET #edit' do
    subject { get :edit, params: { id: '1' } }

    it 'returns http success' do
      is_expected.to have_http_status(200)
    end
  end

  describe 'PUT #update' do
    subject { put :update, params: { id: '1' } }

    it 'returns http success' do
      is_expected.to have_http_status(204)
    end
  end
end
