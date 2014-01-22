# Rack::BackDoor

Inject a user into a session for integration and controller tests.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-back_door'
```

And then execute:

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install rack-back_door
```

## Usage

#### Usage in Rails tests

Add the middleware to your stack in the `config/environments/test.rb` file

```ruby
# config/environments/test.rb

MyApplication::Application.configure do |config|
# ...
  config.middleware.use Rack::BackDoor
# ...
end
```

or, in `rspec` spec helper

```ruby
# spec/spec_helper.rb
MyApplication::Application.configure do |config|
  config.middleware.use Rack::BackDoor
end
```

#### Usage in Sinatra Tests

Add to your sinatra application:

```ruby
# app.rb
class MySinatraApplication < Sinatra::Base
  enable :sessions
  use Rack::BackDoor if environment == :test
  # ...
end
```

If you use rspec you may prefer to inject middleware only for `rspec` tests:

Put into `spec/spec_helper.rb`:

```ruby
# spec/spec_helper.rb
MySinatraApplication.configure do
  use Rack::BackDoor
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
