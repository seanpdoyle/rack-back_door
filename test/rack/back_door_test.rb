$LOAD_PATH.unshift File.expand_path("../../../lib", __FILE__)

require "minitest/autorun"
require "rack/mock"
require "rack/back_door"

class Rack::BackDoorTest < Minitest::Test
  def test_does_nothing_without_url_parameter
    middleware = Rack::BackDoor.new(app)
    request = request_for("http://example.com")

    _, env = middleware.call(request)

    refute env_authenticated_with?(env, "user_id" => 1)
  end

  def test_authenticates_user_from_url_parameter
    middleware = Rack::BackDoor.new(app)
    request = request_for("http://example.com?as=1")

    _, env = middleware.call(request)

    assert env_authenticated_with?(env, "user_id" => 1)
  end

  def test_url_parameter_is_configurable
    middleware = Rack::BackDoor.new(app, url_parameter: "login")
    request = request_for("http://example.com?login=1")

    _, env = middleware.call(request)

    assert env_authenticated_with?(env, "user_id" => 1)
  end

  def test_session_key_is_configurable
    middleware = Rack::BackDoor.new(app, session_key: "user")
    request = request_for("http://example.com?as=1")

    _, env = middleware.call(request)

    assert env_authenticated_with?(env, "user" => 1)
  end

  def request_for(url, **options)
    Rack::MockRequest.env_for(url, options)
  end

  def env_authenticated_with?(env, auth_hash)
    session     = env.fetch("rack.session", {})
    session_key, user_id = auth_hash.first.map(&:to_s)

    signed_in_user = session[session_key].to_i

    user_id.to_i == signed_in_user
  end

  def app
    ->(env) { [200, env, "success!"] }
  end
end
