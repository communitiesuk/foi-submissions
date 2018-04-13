# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindableFoiRequest do
  include_context 'FOI Request Scope'

  let(:foi_request) { build_stubbed(:foi_request) }

  controller(ApplicationController) do
    include FindableFoiRequest

    def index
      redirect_to edit_foi_request_path(@foi_request)
    end
  end

  describe 'GET #index' do
    subject { get :index, params: { request_id: '1' } }

    it 'finds FOI request and sets instance variable' do
      expect(foi_request_scope).to receive(:find_by).
        with(id: '1').and_return(foi_request)
      is_expected.to redirect_to(edit_foi_request_path(foi_request))
    end
  end
end
