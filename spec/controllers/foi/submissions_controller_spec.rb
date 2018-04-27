# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Foi::SubmissionsController, type: :controller do
  include_context 'FOI Request Scope'

  let(:foi_request) { build_stubbed(:foi_request) }
  let(:submission) { build_stubbed(:submission) }

  before do
    allow(foi_request_scope).to receive(:find_by).
      with(id: '1').and_return(foi_request)
  end

  shared_examples 'redirect if missing contact' do
    context 'withont contact' do
      let(:foi_request) { build_stubbed(:foi_request, contact: nil) }

      it 'redirects to new foi_request contact' do
        is_expected.to redirect_to(new_foi_request_contact_path)
      end
    end
  end

  describe 'GET #new' do
    subject { get :new, session: { request_id: '1' } }

    include_examples 'redirect if missing contact'

    it 'returns http success' do
      is_expected.to have_http_status(200)
    end
  end

  describe 'POST #create' do
    subject { post :create, session: { request_id: '1' } }
    before do
      allow(foi_request).to receive(:build_submission).and_return(submission)
    end

    include_examples 'redirect if missing contact'

    context 'queueable' do
      before { allow(submission).to receive(:queue).and_return(true) }

      it 'must queue submission' do
        expect(submission).to receive(:queue)
        subject
      end

      it 'redirects to foi_request sent' do
        is_expected.to redirect_to(sent_foi_request_path)
      end
    end

    context 'unqueueable' do
      before { allow(submission).to receive(:queue).and_return(false) }

      it 'returns http success' do
        is_expected.to have_http_status(200)
      end
    end
  end

  describe 'GET #show' do
    subject { get :show, session: { request_id: '1' } }

    include_examples 'redirect if missing contact'

    it 'returns http success' do
      is_expected.to have_http_status(200)
    end
  end
end
