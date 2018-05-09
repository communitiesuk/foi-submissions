# frozen_string_literal: true

require 'mysociety/redis'

Redis.current = MySociety::Redis.create
