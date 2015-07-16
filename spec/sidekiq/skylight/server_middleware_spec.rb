require 'spec_helper'

describe Sidekiq::Skylight::ServerMiddleware do
  subject(:middleware){described_class.new}

  let(:configuration) { Sidekiq::Skylight::Configuration.new }

  FakeWorker = Class.new
  BlacklistedWorker = Class.new

  it 'wraps block in skylight instrument' do
    expect(::Skylight).to receive(:trace).with('FakeWorker#perform', 'app.sidekiq.worker', 'process'){|&block| block.call}

    expect{|probe| middleware.call(FakeWorker.new, double(:job), double(:queue), &probe)}.to yield_control
  end

  it 'does not instrument a blacklisted worker' do
    configuration.blacklisted_workers = ['BlacklistedWorker']

    allow(::Skylight).to receive(:trace)
    allow(Sidekiq::Skylight).to receive(:config).and_return(configuration)

    middleware.call(BlacklistedWorker.new, double(:job), double(:queue)) do
      puts 'running my blacklisted job'
    end

    expect(::Skylight).not_to have_received(:trace)

    middleware.call(FakeWorker.new, double(:job), double(:queue)) do
      puts 'running my job'
    end

    expect(::Skylight).to have_received(:trace)
  end
end
