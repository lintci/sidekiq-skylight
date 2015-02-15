require 'skylight'

module Sidekiq
  module Skylight
    class ServerMiddleware
      def call(worker, job, queue)
        ::Skylight.instrument(category: 'app.sidekiq.worker', title: 'process') do
          yield
        end
      end
    end
  end
end
