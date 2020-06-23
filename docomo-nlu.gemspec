# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "docomo_nlu/version"

Gem::Specification.new do |spec|
  spec.name          = "docomo-nlu"
  spec.version       = DocomoNlu::VERSION
  spec.authors       = ["Koji Yamazaki"]
  spec.email         = ["kouji.yamazaki.cv@nttdocomo.com"]

  spec.summary       = "API Client of docomo NLPManagementAPI for ruby."
  spec.description   = "API Client of docomo NLPManagementAPI for ruby."
  spec.homepage      = "https://github.com/jagrament/docomo-nlu"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activeresource", ">= 5.0", "< 5.2"
  spec.add_dependency "bundler"
  spec.add_dependency "faraday"
  spec.add_dependency "rake"
  spec.add_dependency "rubyzip"
  spec.add_development_dependency "pry", "~> 0.11.3"
  spec.add_development_dependency "rails"
  spec.add_development_dependency "reek"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rspec", "~> 1.35.0"
  spec.add_development_dependency "vcr", "~> 5.1.0"
  spec.add_development_dependency "webmock", "~> 3.5.0"
end
