# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Foi::ContactsController, type: :controller do
  include_context 'FOI Request Scope'

  let(:foi_request) { build_stubbed(:foi_request) }
  let(:contact) { build_stubbed(:contact) }
  let(:valid_params) { { full_name: 'Spock', email: 'spock@localhost' } }
  let(:invalid_params) { { invalid: true } }

  before do
    allow(foi_request_scope).to receive(:find_by).
      with(id: '1').and_return(foi_request)
  end

  describe 'GET #new' do
    subject { get :new, params: { request_id: '1' } }
    before { allow(foi_request).to receive(:contact).and_return(nil) }

    context 'existing contact' do
      before { allow(foi_request).to receive(:contact).and_return(double) }

      it 'redirects to edit contact' do
        is_expected.to redirect_to(edit_foi_request_contact_path(foi_request))
      end
    end

    context 'new contact' do
      it 'returns http success' do
        is_expected.to have_http_status(200)
      end
    end
  end

  describe 'POST #create' do
    before do
      allow(foi_request).to receive(:contact).and_return(nil)
      allow(foi_request).to receive(:build_contact).and_return(contact)
    end

    context 'existing contact' do
      subject do
        post :create, params: { request_id: '1' }
      end
      before { allow(foi_request).to receive(:contact).and_return(double) }

      it 'does not receive attributes' do
        expect(contact).to_not receive(:update)
        subject
      end

      it 'redirects to edit contact' do
        is_expected.to redirect_to(edit_foi_request_contact_path(foi_request))
      end
    end

    context 'valid parameters' do
      subject do
        post :create, params: { request_id: '1', contact: valid_params }
      end
      before { allow(contact).to receive(:update).and_return(true) }

      it 'receives valid attributes' do
        expect(contact).to receive(:update).
          with(ActionController::Parameters.new(valid_params).permit!)
        subject
      end

      it 'redirects to foi_request' do
        is_expected.to redirect_to(foi_request_preview_path(foi_request))
      end
    end

    context 'invalid parameters' do
      subject do
        post :create, params: { request_id: '1', contact: invalid_params }
      end
      before { allow(contact).to receive(:update).and_return(false) }

      it 'returns http success' do
        is_expected.to have_http_status(200)
      end
    end
  end

  describe 'GET #edit' do
    subject { get :edit, params: { request_id: '1' } }

    it 'returns http success' do
      is_expected.to have_http_status(200)
    end
  end

  describe 'PUT #update' do
    before { allow(foi_request).to receive(:contact).and_return(contact) }

    context 'valid parameters' do
      subject do
        put :update, params: { request_id: '1', contact: valid_params }
      end
      before { allow(contact).to receive(:update).and_return(true) }

      it 'receives valid attributes' do
        expect(contact).to receive(:update).
          with(ActionController::Parameters.new(valid_params).permit!)
        subject
      end

      it 'redirects to foi_request' do
        is_expected.to redirect_to(foi_request_preview_path(foi_request))
      end
    end

    context 'invalid parameters' do
      subject do
        put :update, params: { request_id: '1', contact: invalid_params }
      end
      before { allow(contact).to receive(:update).and_return(false) }

      it 'returns http success' do
        is_expected.to have_http_status(200)
      end
    end
  end
end
