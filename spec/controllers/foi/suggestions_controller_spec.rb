# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Foi::SuggestionsController, type: :controller do
  include_context 'FOI Request Scope'

  let(:foi_request) { build_stubbed(:foi_request) }

  before do
    allow(foi_request_scope).to receive(:find_by).
      with(id: '1').and_return(foi_request)
  end

  describe 'GET #index' do
    subject { get :index, session: { request_id: '1' } }

    context 'there are suggestions' do
      before do
        allow(FoiSuggestion).
          to receive(:from_request).with(foi_request).and_return([double])
      end

      it 'returns http success' do
        is_expected.to have_http_status(200)
      end
    end

    context 'there are no suggestions' do
      before do
        allow(FoiSuggestion).
          to receive(:from_request).with(foi_request).and_return([])
      end

      it 'redirects to the next step' do
        is_expected.to redirect_to(new_foi_request_contact_path)
      end
    end
  end
end
