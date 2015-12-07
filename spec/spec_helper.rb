$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# Require necessary files for sidekiq to believe it's running in server mode
require 'sidekiq/version'
require 'celluloid' if Sidekiq::VERSION < "4.0.0"
require 'sidekiq/cli'
require 'sidekiq/launcher'

require 'sidekiq/skylight'
