# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metoffice_datapoint/version'

Gem::Specification.new do |spec|
  spec.name          = "metoffice_datapoint"
  spec.version       = MetofficeDatapoint::VERSION
  spec.authors       = ["Tim Heighes"]
  spec.email         = ["tim@heighes.com"]
  spec.description   = %q{Simple wrapper for the Met Office DataPoint API}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/sauy7/metoffice_datapoint"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'addressable', '~> 2.3.4'
  spec.add_dependency 'hashie', '~> 2.0.5'
  spec.add_dependency 'multi_json', '~> 1.7.6'
  spec.add_dependency 'rest-client', '~> 1.6.7'

  spec.add_development_dependency 'bundler', '~> 1.3.5'
  spec.add_development_dependency 'rake', '~> 10.0.4'
  spec.add_development_dependency 'minitest', '~> 4.7.4'
  spec.add_development_dependency 'minitest-focus'
  spec.add_development_dependency 'minitest-metadata'
  spec.add_development_dependency 'simplecov', '~> 0.7.1'
  spec.add_development_dependency 'tomdoc', '~> 0.2.5'
  spec.add_development_dependency 'webmock', '~> 1.11.0'
  spec.add_development_dependency 'vcr', '~> 2.5.0'
end