# Rack::BackDoor

[![Build
Status](https://travis-ci.org/seanpdoyle/rack-back_door.svg)](https://travis-ci.org/seanpdoyle/rack-back_door)

Inject a user into a session for integration and controller tests.

Inspired by [thoughtbot's](http://thoughtbot.com) [clearance](https://github.com/thoughtbot/clearance/blob/b2f4b240a8ee2dbb1e8679274aa188629f2e3796/lib/clearance/back_door.rb) gem

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

# Usage

By default, `Rack::BackDoor` will handle the following URL:

```
http://example.com?as=1
```

By injecting `1` into the `session` as `user_id`

```ruby
session[:user_id]   # => 1
```

## Setup in Rails tests

Add the middleware to your stack in the `config/environments/test.rb` file

```ruby
# config/environments/test.rb

MyApplication::Application.configure do |config|
# ...
  config.middleware.use Rack::BackDoor
# ...
end
```

## Setup in Sinatra Tests

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

## Configuration

You can configure the following:

* `session_key` - The key used to hold the `user_id` in the session
* `url_parameter` - The query parameter the middleware will use as the `user_id` value

When configured with these values and passed the following URL

   http://example.com?login=1

The middleware will set the session like so

```ruby
session[:user]  #=> 1
```

To configure the middleware in a `sinatra` app:

```ruby
# app.rb
class MySinatraApplication < Sinatra::Base
  enable :sessions

  if environment == "test"
    use Rack::BackDoor, session_key: "user", url_parameter: "login"
  end

  # ...
end
```

To configure the middleware in a `rails` app:

```ruby
# config/test.rb
MyApplication::Application.configure do |config|
# ...
  config.middleware.use "Rack::BackDoor", session_key: "user", url_parameter: "login"
# ...
end
```

Additionally, you can override the middleware to alter the `rack` request any
way you see fit by configuring the `middleware` with a block.

For instance, in `sinatra`:

```ruby
use Rack::BackDoor do |env, user_id|
  env['my.user'] = User.find(user_id)
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
