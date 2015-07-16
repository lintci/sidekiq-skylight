require 'spec_helper'

describe Sidekiq::Skylight::ServerMiddleware do
  subject(:middleware){described_class.new}

  FakeWorker = Class.new
  BlacklistedWorker = Class.new

  it 'wraps block in skylight instrument' do
    expect(::Skylight).to receive(:trace).with('FakeWorker#perform', 'app.sidekiq.worker', 'process'){|&block| block.call}

    expect{|probe| middleware.call(FakeWorker.new, double(:job), double(:queue), &probe)}.to yield_control
  end

  context 'with blacklisted workers' do
    around(:each) do |example|
      previous_blacklisted = Sidekiq::Skylight.config.blacklisted_workers
      Sidekiq::Skylight.config.blacklisted_workers = %w(BlacklistedWorker)

      example.run

      Sidekiq::Skylight.config.blacklisted_workers = previous_blacklisted
    end

    it 'does not instrument a blacklisted worker' do
      expect(::Skylight).to_not receive(:trace)

      expect{|probe| middleware.call(BlacklistedWorker.new, double(:job), double(:queue), &probe)}.to yield_control
    end

    it 'still instruments non-blacklisted workers' do
      expect(::Skylight).to receive(:trace).with('FakeWorker#perform', 'app.sidekiq.worker', 'process'){|&block| block.call}

      expect{|probe| middleware.call(FakeWorker.new, double(:job), double(:queue), &probe)}.to yield_control
    end
  end
end
