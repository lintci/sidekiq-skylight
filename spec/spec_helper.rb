$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# Require necessary files for sidekiq to believe it's running in server mode
require 'celluloid'
require 'sidekiq/cli'
require 'sidekiq/launcher'

require 'sidekiq/skylight'
