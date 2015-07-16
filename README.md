# Sidekiq::Skylight

[![Circle CI](https://circleci.com/gh/lintci/sidekiq-skylight.svg?style=svg)](https://circleci.com/gh/lintci/sidekiq-skylight)

Middleware for instrumenting Sidekiq with Skylight.io

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sidekiq-skylight'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sidekiq-skylight

## Blacklisted Jobs

If there's a job that you don't want to be instrumented via Skylight, you can
use the `blacklisted_workers` config option like so:

```ruby
Sidekiq::Skylight.configure do |config|
  config.blacklisted_workers = ['BlacklistedWorker']
end
```

Any workers with the class names you specify will be ignored from any Skylight tracing.

## Usage

Make sure you've setup skylight.io for your project already. Everything else should be automatic.

## Contributing

1. Fork it ( https://github.com/lintci/sidekiq-skylight/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
