# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  controller do
    def index
      render plain: 'success'
    end
  end

  context 'with current user and valid authenticated until' do
    it 'renders action' do
      expect(User).to receive(:find_by).with(uid: 123).and_return(build(:user))
      get :index, session: {
        current_user: 123,
        authenticated_until: (Time.zone.now + 1.minute).to_i
      }
      expect(response.body).to eq 'success'
    end
  end

  context 'without current user' do
    it 'redirects to google authenication page' do
      expect(User).to receive(:find_by).with(uid: 789).and_return(nil)
      get :index, session: {
        current_user: 789,
        authenticated_until: (Time.zone.now + 1.minute).to_i
      }
      expect(response).to redirect_to('/auth/google')
    end
  end

  context 'without valid authenticated until' do
    it 'redirects to google authenication page' do
      expect(User).to receive(:find_by).with(uid: 123).and_return(build(:user))
      get :index, session: {
        current_user: 123,
        authenticated_until: (Time.zone.now - 1.minute).to_i
      }
      expect(response).to redirect_to('/auth/google')
    end
  end
end
