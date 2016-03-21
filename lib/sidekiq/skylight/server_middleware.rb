require 'skylight'

module Sidekiq
  module Skylight
    class ServerMiddleware
      def call(worker, job, _queue)
        name = expand_worker_name(worker, job)
        if blacklisted?(worker, name)
          yield
        else
          ::Skylight.trace("#{name}#perform", 'app.sidekiq.worker', 'process', &Proc.new)
        end
      end

      def config
        Sidekiq::Skylight.config
      end

      private

      def blacklisted?(worker, name)
        config.blacklisted_workers.include?(name) ||
          (worker.respond_to?(:blacklisted_for_skylight?) &&
           worker.blacklisted_for_skylight?)
      end

      def expand_worker_name(worker, job)
        job['wrapped'] || worker.class.name
      end
    end
  end
end
