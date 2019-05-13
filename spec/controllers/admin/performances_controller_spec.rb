# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::PerformancesController, type: :controller do
  let(:performance) { build_stubbed(:performance) }
  let(:valid_params) { { percentage: '72' } }
  let(:invalid_params) { { invalid: true } }

  let(:session) do
    { current_user: 123, authenticated_until: (Time.zone.now + 1.hour).to_i }
  end

  before do
    allow(User).to receive(:find_by).with(uid: 123).and_return(build(:user))
  end

  describe 'GET #show' do
    subject { get :show, session: session }

    it 'returns http success' do
      is_expected.to have_http_status(200)
    end
  end

  describe 'GET #new' do
    subject { get :new, session: session }

    it 'returns http success' do
      is_expected.to have_http_status(200)
    end
  end

  describe 'POST #create' do
    before { allow(Performance).to receive(:new).and_return(performance) }

    context 'valid parameters' do
      subject do
        post :create, params: { performance: valid_params }, session: session
      end
      before { allow(performance).to receive(:update).and_return(true) }

      it 'receives valid attributes' do
        expect(performance).to receive(:update).
          with(ActionController::Parameters.new(valid_params).permit!)
        subject
      end

      it 'redirects to show' do
        is_expected.to redirect_to(admin_performance_path)
      end

      it 'sets flash notice' do
        subject
        expect(flash.notice).to_not be_nil
      end
    end

    context 'invalid parameters' do
      subject do
        post :create, params: { performance: invalid_params },
                      session: session
      end
      before { allow(performance).to receive(:update).and_return(false) }

      it 'returns http success' do
        is_expected.to have_http_status(200)
      end
    end
  end
end
