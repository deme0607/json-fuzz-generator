# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'json/fuzz/generator/version'

Gem::Specification.new do |spec|
  spec.name          = "json-fuzz-generator"
  spec.version       = JSON::Fuzz::Generator::VERSION
  spec.authors       = ["deme0607"]
  spec.email         = ["hcs0035@gmail.com"]
  spec.summary       = %q{Fuzz parameter gemerator from json-schema}
  spec.description   = %q{Fuzz parameter gemerator from json-schema}
  spec.homepage      = "https://github.com/deme0607/json-fuzz-generator"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "json-schema", "< 2.3"
  spec.add_dependency "randexp"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-byebug"
end
