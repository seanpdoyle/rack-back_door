require "sinatra"
require "rack/back_door"

enable :sessions

use Rack::BackDoor, session_key: "user", url_parameter: "login"

get "/" do
  user_id = session["user"]

  session.clear

  user_id
end
