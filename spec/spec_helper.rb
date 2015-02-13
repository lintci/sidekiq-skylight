$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'celluloid'
require 'sidekiq/cli'
require 'sidekiq/launcher'

require 'sidekiq/skylight'
