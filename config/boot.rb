# frozen_string_literal: true

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

begin
  require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
rescue LoadError
  STDERR.puts "Couldn't find Bootsnap in the current environment"
end

# TODO: Remove this. This is a hacky system for having a default environment.
# It looks for a config/rails_env.rb file, and reads stuff from there if
# it exists. Put just a line like this in there:
#   ENV['RAILS_ENV'] = 'production'
rails_env_file = File.expand_path(File.join(__dir__, 'rails_env.rb'))
require rails_env_file if File.exist?(rails_env_file)
