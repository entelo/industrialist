lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "industrialist/version"

Gem::Specification.new do |spec|
  spec.name          = "industrialist"
  spec.version       = Industrialist::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Alan Ridlehoover", "Fito von Zastrow"]
  spec.email         = ["dev@entelo.com"]

  spec.summary       = "Industrialist manufactures factories that build self-registered classes."
  spec.homepage      = "https://github.com/entelo/industrialist"
  spec.license       = "MIT"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/entelo/industrialist/issues",
    "homepage_uri" => spec.homepage,
    "source_code_uri" => "https://github.com/entelo/industrialist"
  }

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
