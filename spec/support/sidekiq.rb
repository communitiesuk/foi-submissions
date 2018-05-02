# frozen_string_literal: true

require 'sidekiq/testing'
require 'sidekiq/lock/testing/inline'

RSpec.configure do |config|
  config.before(:each) do
    Sidekiq::Worker.clear_all
  end
end

Sidekiq::Testing.server_middleware do |chain|
  chain.add Sidekiq::Lock::Middleware
end
