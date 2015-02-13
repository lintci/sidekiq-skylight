require 'spec_helper'

describe Sidekiq::Skylight do
  it 'has a version number' do
    expect(Sidekiq::Skylight::VERSION).not_to be nil
  end

  it 'adds Skylight as first server middleware' do
    expect(Sidekiq.server_middleware.entries.first.klass).to eq(Sidekiq::Skylight::ServerMiddleware)
  end
end
