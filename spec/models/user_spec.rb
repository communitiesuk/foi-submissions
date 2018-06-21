# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.find_or_create_with_omniauth' do
    let(:auth_hash) do
      double(:auth_hash, provider: 'google', uid: '007',
                         info: {
                           'email' => 'bond@example.com',
                           'name' => 'James Bond'
                         })
    end

    it 'returns existing users' do
      user = User.create(provider: 'google', uid: '007')
      expect(User.find_or_create_with_omniauth(auth_hash)).to eq user
    end

    it 'creates users with email and name' do
      expect { User.find_or_create_with_omniauth(auth_hash) }.
        to change(User, :count).from(0).to(1)

      user = User.last
      expect(user.email).to eq 'bond@example.com'
      expect(user.name).to eq 'James Bond'
    end
  end
end
