require "rack/utils"

# Force a User to be authenticated
# ala http://robots.thoughtbot.com/post/37907699673/faster-tests-sign-in-through-the-back-door
class Rack::BackDoor
  def initialize(app, options = {})
    @app = app
    @url_parameter = options.fetch(:url_parameter, "as")
    @session_key = options.fetch(:session_key, "user_id")
  end

  def call(env)
    @env = env

    sign_in_through_the_back_door

    app.call(env)
  end

  private

  attr_reader :app, :url_parameter, :session_key, :env

  def sign_in_through_the_back_door
    if user_id = query_params[url_parameter]
      session[session_key] = user_id.to_s
    end
  end

  def session
    env['rack.session'] ||= {}
  end

  def query_params
    Rack::Utils.parse_query(env['QUERY_STRING'])
  end
end
