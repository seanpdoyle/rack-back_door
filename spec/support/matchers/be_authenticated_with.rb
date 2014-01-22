RSpec::Matchers.define :be_authenticated_with do |options|
  match do |env|
    session     = env.fetch("rack.session", {})
    session_key = options.keys.first.to_s
    user_id     = options.values.first.to_i

    expect(session[session_key].to_i).to eq user_id.to_i
  end
end
