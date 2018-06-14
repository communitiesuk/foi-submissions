# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  include_context 'FOI Request Scope'

  describe 'GET #show' do
    subject { get :show, params: { id: '1' }, session: { request_id: '1' } }

    let(:suggestion) { build_stubbed(:foi_suggestion) }
    let(:foi_request) { build_stubbed(:foi_request) }

    before do
      allow(FoiSuggestion).to receive(:find).with('1').and_return(suggestion)
      allow(suggestion).to receive(:clicked!)
      allow(suggestion).to receive(:url).and_return('http://example.com')

      allow(foi_request_scope).to receive(:find_by).
        with(id: '1').and_return(foi_request)
    end

    context 'suggestion for current request' do
      before { suggestion.foi_request = foi_request }

      it 'call clicked! on suggestion' do
        expect(suggestion).to receive(:clicked!)
        subject
      end

      it 'redirects suggestion URL' do
        is_expected.to redirect_to('http://example.com')
      end
    end

    context 'suggestion for another request' do
      before { suggestion.foi_request = build_stubbed(:foi_request) }

      it 'does not call clicked! on suggestion' do
        expect(suggestion).to_not receive(:clicked!)
        subject
      end

      it 'redirects suggestion URL' do
        is_expected.to redirect_to('http://example.com')
      end
    end
  end
end
