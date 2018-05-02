# frozen_string_literal: true

# Example config:
#
# Required:
# - ENV['REDIS_URL'] => 'redis://:[password]@[hostname]:[port]/[db]'
# or
# - ENV['REDIS_URL'] => 'redis://[master_name]/[db]'
# - ENV['REDIS_SENTINELS'] => '0.0.0.0:26380,0.0.0.0:26381,...'
#
# Optional:
# - ENV['REDIS_NAMESPACE'] => 'foi_for_councils'

if ENV['REDIS_SENTINELS']
  sentinels = ENV['REDIS_SENTINELS'].split(',').map do |ip_and_port|
    ip, port = ip_and_port.split(':')
    { host: ip, port: port&.to_i || 26_379 }
  end

  redis_options = { sentinels: sentinels, role: :master }
end

redis_options ||= {}
redis_options[:url] = ENV['REDIS_URL']
redis = Redis.new(redis_options)

# Enable deprecation of administrative commands when using namesapces. This will
# be the default for redis-namespace v2.x
ENV['REDIS_NAMESPACE_DEPRECATIONS'] = '1'

namespace = [ENV['REDIS_NAMESPACE'], Rails.env].compact.join('-')
Redis.current = Redis::Namespace.new(namespace, redis: redis)
