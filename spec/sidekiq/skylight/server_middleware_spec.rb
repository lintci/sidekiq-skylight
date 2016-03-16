require 'spec_helper'

describe Sidekiq::Skylight::ServerMiddleware do
  subject(:middleware){described_class.new}

  FakeWorker = Class.new
  BlacklistedWorker = Class.new
  BlacklistedWorkerByType = Class.new
  BlacklistedWorkerByType.include(Sidekiq::Skylight::Blacklisted)

  shared_examples "an unblacklisted worker" do
    it 'wraps block in skylight instrument' do
      expect(::Skylight)
        .to receive(:trace)
        .with('FakeWorker#perform', 'app.sidekiq.worker', 'process')
        .and_yield
      expect { |probe| middleware.call(FakeWorker.new, {}, double(:queue), &probe) }
        .to yield_control
    end
  end

  it_behaves_like "an unblacklisted worker"

  context 'with blacklisted workers' do
    context "based on configuration" do
      around(:each) do |example|
        previous_blacklisted = Sidekiq::Skylight.config.blacklisted_workers
        Sidekiq::Skylight.config.blacklisted_workers = %w(BlacklistedWorker)

        example.run

        Sidekiq::Skylight.config.blacklisted_workers = previous_blacklisted
      end

      it 'does not instrument a blacklisted worker' do
        expect(::Skylight).to_not receive(:trace)

        expect{|probe| middleware.call(BlacklistedWorker.new, {}, double(:queue), &probe)}.to yield_control
      end

      it_behaves_like "an unblacklisted worker"
    end

    context "based on type" do
      it 'does not instrument a blacklisted worker' do
        expect(::Skylight).to_not receive(:trace)

        expect { |probe| middleware.call(BlacklistedWorkerByType.new, {}, double(:queue), &probe) }
          .to yield_control
      end

      it_behaves_like "an unblacklisted worker"
    end
  end

  context 'with a wrapped job' do
    around(:each) do |example|
      previous_blacklisted = Sidekiq::Skylight.config.blacklisted_workers
      Sidekiq::Skylight.config.blacklisted_workers = %w(BlacklistedWrappedWorker)

      example.run

      Sidekiq::Skylight.config.blacklisted_workers = previous_blacklisted
    end

    it 'does not instrument a blacklisted worker' do
      expect(::Skylight).to_not receive(:trace)

      expect{|probe| middleware.call(FakeWorker.new, {'wrapped' => 'BlacklistedWrappedWorker'}, double(:queue), &probe)}.to yield_control
    end

    it 'still instruments non-blacklisted workers' do
      expect(::Skylight).to receive(:trace).with('WrappedWorker#perform', 'app.sidekiq.worker', 'process') do |&block|
        block.call
      end

      expect{|probe| middleware.call(FakeWorker.new, {'wrapped' => 'WrappedWorker'}, double(:queue), &probe)}.to yield_control
    end
  end
end
