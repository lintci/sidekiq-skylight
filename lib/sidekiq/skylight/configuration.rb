module Sidekiq
  module Skylight
    class Configuration
      attr_accessor :blacklisted_workers

      def blacklisted_workers
        @blacklisted_workers ||= []
      end
    end

    def self.config
      @configuration ||= Configuration.new
    end

    def self.configure
      yield config
    end
  end
end
