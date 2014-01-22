require 'spec_helper'
require 'pry'

describe Rack::BackDoor do
  let(:app) { ->(env) { [200, env, "app"] } }

  let :middleware do
    Rack::BackDoor.new(app)
  end

  before do
    Rack::BackDoor.configuration = nil
  end

  context "without the backdoor URL parameter" do
    it "does nothing to the session" do
      code, env = middleware.call env_for('http://example.com')

      expect(env).not_to be_authenticated_with "user_id" => 1
    end
  end

  context "with the backdoor URL parameter" do
    it "stuffs the session" do
      code, env = middleware.call env_for('http://example.com?as=1')

      expect(env).to be_authenticated_with "user_id" => 1
    end

    context "when the URL parameter is configured" do
      before do
        Rack::BackDoor.configure do |config|
          config.url_parameter = :login
        end
      end

      it "stuffs the session with the default key" do
        code, env = middleware.call env_for('http://example.com?login=1')

        expect(env).to be_authenticated_with "user_id" => 1
      end
    end

    context "when the session key is configured" do
      before do
        Rack::BackDoor.configure do |config|
          config.session_key = :user
        end
      end

      it "stuffs the session with the configured key" do
        code, env = middleware.call env_for('http://example.com?as=1')

        expect(env).to be_authenticated_with "user" => 1
      end
    end
  end

  def env_for(url, opts={})
    Rack::MockRequest.env_for(url, opts)
  end
end