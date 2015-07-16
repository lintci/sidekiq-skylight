require 'skylight'

module Sidekiq
  module Skylight
    class ServerMiddleware
      def call(worker, job, queue)
        if config.blacklisted_workers.include?(worker.class.name)
          yield
        else
          ::Skylight.trace("#{worker.class.to_s}#perform", 'app.sidekiq.worker', 'process', &Proc.new)
        end
      end

      def config
        Sidekiq::Skylight.config
      end
    end
  end
end
