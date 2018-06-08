# frozen_string_literal: true

##
# This model represents a user which has authenticate via OmniAuth
#
class User < ApplicationRecord
  def self.find_or_create_with_omniauth(auth_hash)
    arguments = { provider: auth_hash.provider, uid: auth_hash.uid }

    User.find_or_create_by(arguments) do |user|
      user.email = auth_hash.info['email']
      user.name = auth_hash.info['name']
    end
  end
end
