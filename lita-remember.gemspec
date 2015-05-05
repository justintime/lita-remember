Gem::Specification.new do |spec|
  spec.name          = "lita-remember"
  spec.version       = "0.0.1"
  spec.authors       = ["Justin Ellison"]
  spec.email         = ["justin@techadvise.com"]
  spec.description   = "A Lita plugin that remembers terms and definitions."
  spec.summary       = "A Lita plugin that remembers terms and definitions."
  spec.homepage      = "https://github.com/justintime/lita-remember"
  spec.license       = "TODO: Add a license"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.3"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "guard-rspec"
end
