# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #new' do
    context 'with invalid credentials' do
      subject { get :new, params: { message: 'invalid_credentials' } }
      it { is_expected.to have_http_status(401) }
    end

    context 'other errors' do
      subject { get :new, params: { message: 'other' } }
      it { is_expected.to redirect_to('/auth/google') }
    end
  end

  describe 'GET #create' do
    let(:user) { build(:user) }
    let(:auth_hash) do
      double(:auth_hash, provider: 'google', credentials:
             double(expires_at: '123'))
    end

    subject { get :create, params: { provider: auth_hash.provider } }

    before do
      request.env['omniauth.auth'] = auth_hash
      allow(User).to receive(:find_or_create_with_omniauth).
        and_return(user)
    end

    it 'find or creates user' do
      expect(User).to receive(:find_or_create_with_omniauth).with(auth_hash)
      subject
    end

    it 'stores current user UID in session' do
      expect { subject }.to(change { session[:current_user] })
      expect(session[:current_user]).to eq user.uid
    end

    it 'stores current provider in session' do
      expect { subject }.to(change { session[:current_provider] })
      expect(session[:current_provider]).to eq 'google'
    end

    it 'stores authenticated until in session' do
      expect { subject }.to(change { session[:authenticated_until] })
      expect(session[:authenticated_until]).to eq '123'
    end

    it 'redirects back to previous action' do
      session[:redirect_to] = root_path
      is_expected.to redirect_to(root_path)
    end

    it 'redirects back to admin' do
      is_expected.to redirect_to(admin_root_path)
    end
  end
end
