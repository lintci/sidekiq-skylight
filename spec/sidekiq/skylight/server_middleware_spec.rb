require 'spec_helper'

describe Sidekiq::Skylight::ServerMiddleware do
  subject(:middleware){described_class.new}

  it 'wraps block in skylight instrument' do
    expect(::Skylight).to receive(:instrument).with(category: 'app.sidekiq.worker', title: 'process'){|&block| block.call}

    expect{|probe| middleware.call(double(:worker), double(:job), double(:queue), &probe)}.to yield_control
  end
end
