# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'netforum/version'

Gem::Specification.new do |spec|
  spec.name          = "netforum"
  spec.version       = Netforum::VERSION
  spec.authors       = ["Marc Villanueva"]
  spec.email         = ["mvillanueva@blueskybroadcast.com"]
  spec.summary       = %q{Gem to interact with Avectra's Netforum Pro API.}
  spec.description   = %q{Gem to interact with Avectra's Netforum Pro API.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "savon", "~> 2.0"
  spec.add_dependency "httpclient", "~> 2.0"
  spec.add_dependency "hashie"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'byebug'
end
