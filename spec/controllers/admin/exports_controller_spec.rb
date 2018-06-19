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

    let!(:resource) do
      link = create(:curated_link_with_suggestions)
      Resource.find_by(resource_id: link.id, resource_type: 'CuratedLink')
    end
    let(:lines) { response.body.split("\n") }

    it 'should return a CSV' do
      is_expected.to have_http_status(200)
      expect(response.content_type).to eq 'text/csv'
    end

    it 'should have CSV headers' do
      expect(lines).to include(
        'id,title,url,keywords,shown,' \
        'click_rate,answer_rate,created_at,updated_at'
      )
    end

    it 'should have CSV data' do
      expect(lines).to include([
        resource.id,
        resource.title, resource.url, resource.keywords,
        resource.shown, resource.click_rate, resource.answer_rate,
        resource.created_at.to_s(:db), resource.updated_at.to_s(:db)
      ].join(','))
    end
  end
end
