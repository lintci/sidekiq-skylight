require 'spec_helper'

describe Sidekiq::Skylight::ServerMiddleware do
  subject(:middleware){described_class.new}

  FakeWorker = Class.new

  it 'wraps block in skylight instrument' do
    expect(::Skylight).to receive(:trace).with('FakeWorker#perform', 'app.sidekiq.worker', 'process'){|&block| block.call}

    expect{|probe| middleware.call(FakeWorker.new, double(:job), double(:queue), &probe)}.to yield_control
  end
end
