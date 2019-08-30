# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'],
           name: 'google', hd: %w[mysociety.org communities.gov.uk],
           prompt: 'select_account'
end

OmniAuth.config.failure_raise_out_environments = []
