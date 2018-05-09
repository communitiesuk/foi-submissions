# frozen_string_literal: true

require_relative 'redis.rb'

redis_connection = proc { Redis.current }

Sidekiq.configure_server do |config|
  # https://github.com/moove-it/sidekiq-scheduler#notes-about-connection-pooling
  config.redis = ConnectionPool.new(size: 58, &redis_connection)
end

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 5, &redis_connection)
end
