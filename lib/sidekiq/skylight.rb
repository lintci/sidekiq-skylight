require 'sidekiq'

require_relative 'skylight/version'
require_relative 'skylight/server_middleware'
require_relative 'skylight/blacklisted'
require_relative 'skylight/configuration'

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.prepend Sidekiq::Skylight::ServerMiddleware
  end
end
