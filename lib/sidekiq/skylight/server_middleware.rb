require 'skylight'

module Sidekiq
  module Skylight
    class ServerMiddleware
      def call(worker, job, queue)
        ::Skylight.trace("#{worker.class.to_s}#perform", 'app.sidekiq.worker', 'process') do
          yield
        end
      end
    end
  end
end
