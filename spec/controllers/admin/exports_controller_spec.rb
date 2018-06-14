# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ExportsController, type: :controller do
  let(:session) do
    { current_user: 123, authenticated_until: (Time.zone.now + 1.hour).to_i }
  end

  before do
    allow(User).to receive(:find_by).with(uid: 123).and_return(build(:user))
  end

  describe 'GET #show' do
    subject(:response) do
      get :show, params: { format: 'csv' }, session: session
    end

    let!(:suggestion) { create(:foi_suggestion) }

    it 'should return a CSV' do
      is_expected.to have_http_status(200)
      expect(response.content_type).to eq 'text/csv'
    end

    it 'should have CSV headers' do
      lines = response.body.split("\n")

      expect(lines).to include(
        'id,title,url,keywords,shown,' \
        'click_rate,answer_rate,created_at,updated_at'
      )
    end

    it 'should have CSV data' do
      link = suggestion.resource
      lines = response.body.split("\n")

      expect(lines).to include([
        link.id, link.title, link.url, link.keywords, link.shown,
        link.click_rate, link.answer_rate, link.created_at, link.updated_at
      ].join(','))
    end
  end
end
