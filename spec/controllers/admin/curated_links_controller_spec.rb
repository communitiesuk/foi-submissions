# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::CuratedLinksController, type: :controller do
  let(:curated_link) { build_stubbed(:curated_link) }
  let(:valid_params) { { title: 'Title', url: 'https://www.example.com' } }
  let(:invalid_params) { { invalid: true } }

  let(:session) do
    { current_user: 123, authenticated_until: (Time.zone.now + 1.hour).to_i }
  end

  before do
    allow(User).to receive(:find_by).with(uid: 123).and_return(build(:user))
  end

  describe 'GET #index' do
    subject { get :index, session: session }

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
    before { allow(CuratedLink).to receive(:new).and_return(curated_link) }

    context 'valid parameters' do
      subject do
        post :create, params: { curated_link: valid_params }, session: session
      end
      before { allow(curated_link).to receive(:update).and_return(true) }

      it 'receives valid attributes' do
        expect(curated_link).to receive(:update).
          with(ActionController::Parameters.new(valid_params).permit!)
        subject
      end

      it 'redirects to index' do
        is_expected.to redirect_to(admin_curated_links_path)
      end

      it 'sets flash notice' do
        subject
        expect(flash.notice).to_not be_nil
      end
    end

    context 'invalid parameters' do
      subject do
        post :create, params: { curated_link: invalid_params },
                      session: session
      end
      before { allow(curated_link).to receive(:update).and_return(false) }

      it 'returns http success' do
        is_expected.to have_http_status(200)
      end
    end
  end

  describe 'GET #edit' do
    subject { get :edit, params: { id: 1 }, session: session }
    before do
      allow(CuratedLink).to receive(:find).with('1').and_return(curated_link)
    end

    it 'returns http success' do
      is_expected.to have_http_status(200)
    end
  end

  describe 'PUT #update' do
    before do
      allow(CuratedLink).to receive(:find).with('1').and_return(curated_link)
    end

    context 'valid parameters' do
      subject do
        put :update, params: { id: '1', curated_link: valid_params },
                     session: session
      end
      before { allow(curated_link).to receive(:update).and_return(true) }

      it 'receives valid attributes' do
        expect(curated_link).to receive(:update).
          with(ActionController::Parameters.new(valid_params).permit!)
        subject
      end

      it 'redirects to index' do
        is_expected.to redirect_to(admin_curated_links_path)
      end

      it 'sets flash notice' do
        subject
        expect(flash.notice).to_not be_nil
      end
    end

    context 'invalid parameters' do
      subject do
        put :update, params: { id: '1', curated_link: invalid_params },
                     session: session
      end
      before { allow(curated_link).to receive(:update).and_return(false) }

      it 'returns http success' do
        is_expected.to have_http_status(200)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      allow(CuratedLink).to receive(:find).with('1').and_return(curated_link)
    end

    context 'successful soft-destroy' do
      subject { delete :destroy, params: { id: '1' }, session: session }
      before { allow(curated_link).to receive(:soft_destroy).and_return(true) }

      it 'redirects to index' do
        is_expected.to redirect_to(admin_curated_links_path)
      end

      it 'sets flash notice' do
        subject
        expect(flash.notice).to_not be_nil
      end
    end

    context 'unsuccessful soft-destroy' do
      subject { delete :destroy, params: { id: '1' }, session: session }
      before { allow(curated_link).to receive(:soft_destroy).and_return(false) }

      it 'redirects to edit' do
        is_expected.to redirect_to(edit_admin_curated_link_path(curated_link))
      end

      it 'sets flash alert' do
        subject
        expect(flash.alert).to_not be_nil
      end
    end
  end
end
