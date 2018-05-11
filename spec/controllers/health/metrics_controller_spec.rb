# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Health::MetricsController, type: :controller do
  describe 'GET #index' do
    subject { get :index, format: 'text' }

    it 'returns http success' do
      is_expected.to have_http_status(200)
    end
  end
end
