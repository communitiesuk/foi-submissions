# frozen_string_literal: true

class ApplicationController < ActionController::Base # :nodoc:
  if ENV.key?('HTTP_AUTH_PASSWORD')
    http_basic_authenticate_with name: 'hackney-foi',
                                 password: ENV['HTTP_AUTH_PASSWORD']
  end
end
