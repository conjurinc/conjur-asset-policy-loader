# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'conjur-asset-policy-loader-version'
require 'find'

Gem::Specification.new do |spec|
  spec.name          = "conjur-asset-policy-loader"
  spec.version       = Conjur::Asset::PolicyLoader::VERSION
  spec.authors       = ["Kevin Gilpin"]
  spec.email         = ["kgilpin@conjur.net"]

  spec.summary       = %q{Server-side management of Conjur policies.}
  spec.homepage      = "https://github.com/conjurinc/asset-policy-loader."
  spec.license       = "MIT"

  spec.files         = Find.find('.').reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
