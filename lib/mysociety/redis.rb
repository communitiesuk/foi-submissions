# frozen_string_literal: true

module MySociety
  ##
  # This module parse ENV variables to provide Redis connection options
  #
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
  #
  module Redis
    class << self
      def create
        ::Redis::Namespace.new(namespace, redis: ::Redis.new(options))
      end

      def options_with_namespace
        { namespace: namespace }.merge(options)
      end

      private

      def namespace
        [ENV['REDIS_NAMESPACE'], Rails.env].compact.join('-')
      end

      def options
        { url: ENV['REDIS_URL'] }.merge(sentinel_options)
      end

      def sentinel_options
        return {} unless ENV['REDIS_SENTINELS']

        sentinels = ENV['REDIS_SENTINELS'].split(',').map do |ip_and_port|
          ip, port = ip_and_port.split(':')
          { host: ip, port: port&.to_i || 26_379 }
        end

        { sentinels: sentinels, role: :master }
      end
    end
  end
end
