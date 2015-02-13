require 'sidekiq'

require_relative 'skylight/version'
require_relative 'skylight/server_middleware'

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.prepend Sidekiq::Skylight::ServerMiddleware
  end
end
