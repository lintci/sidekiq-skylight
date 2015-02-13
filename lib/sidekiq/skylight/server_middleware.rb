require 'skylight'

module Sidekiq
  module Skylight
    class ServerMiddleware
      def call(worker, job, queue)
        ::Skylight.instrument(category: 'worker.sidekiq.job', title: 'perform') do
          yield
        end
      end
    end
  end
end
