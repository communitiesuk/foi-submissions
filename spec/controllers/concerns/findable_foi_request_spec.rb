# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindableFoiRequest do
  include_context 'FOI Request Scope'

  let(:foi_request) { build_stubbed(:foi_request) }

  controller(ApplicationController) do
    include FindableFoiRequest

    before_action :find_foi_request

    def index
      redirect_to edit_foi_request_path
    end
  end

  describe 'GET #index' do
    subject { get :index, session: { request_id: '1' } }

    context 'with foi_request' do
      it 'finds FOI request and sets instance variable' do
        expect(foi_request_scope).to receive(:find_by).
          with(id: '1').and_return(foi_request)
        is_expected.to redirect_to(edit_foi_request_path)
      end
    end

    context 'without foi_request' do
      let(:foi_request) { nil }

      before do
        allow(foi_request_scope).to receive(:find_by).
          with(id: '1').and_return(foi_request)
      end

      it 'redirects to new foi_request' do
        is_expected.to redirect_to(new_foi_request_path)
      end
    end
  end
end
