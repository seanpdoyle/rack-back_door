# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "rack-back_door"
  spec.version       = "0.1.0"
  spec.authors       = ["Sean Doyle"]
  spec.email         = ["sean.p.doyle24@gmail.com"]
  spec.summary       = %q{Inject an authenticated user into a Rack session}
  spec.description   = %q{For unit, controller, or integration tests, inject an authenticated user into a Rack session}
  spec.homepage      = "https://github.com/seanpdoyle/rack-back_door"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "sinatra"
end
