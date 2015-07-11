require 'skylight'

module Sidekiq
  module Skylight
    class ServerMiddleware
      def call(worker, job, queue)
        return if config.blacklisted_workers.include? worker.class.name

        ::Skylight.trace("#{worker.class.to_s}#perform", 'app.sidekiq.worker', 'process') do
          yield
        end
      end

      def config
        Sidekiq::Skylight.config
      end
    end
  end
end
