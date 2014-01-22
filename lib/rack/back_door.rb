require 'rack/utils'

# Force a User to be authenticated
# ala http://robots.thoughtbot.com/post/37907699673/faster-tests-sign-in-through-the-back-door
class Rack::BackDoor
  class << self
    attr_accessor :configuration

    def configure
      yield configuration if block_given?
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def url_parameter
      configuration.url_parameter
    end

    def session_key
      configuration.session_key
    end
  end

  class Configuration
    attr_accessor :url_parameter, :session_key

    def initialize
      @url_parameter  = "as"
      @session_key    = "user_id"
    end
  end

  def initialize(app)
    @app = app
  end

  def call(env)
    @env = env
    sign_in_through_the_back_door
    @app.call(@env)
  end

  private

  def session_key
    self.class.session_key.to_s
  end

  def url_parameter
    self.class.url_parameter.to_s
  end

  def sign_in_through_the_back_door
    if user_id = query_params[url_parameter]
      session[session_key] = user_id.to_s
    end
  end

  def session
    @env['rack.session'] ||= {}
  end

  def query_params
    Rack::Utils.parse_query(@env['QUERY_STRING'])
  end
end
