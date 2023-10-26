# frozen_string_literal: true

# Get the GEMFILE_VERSION without *require* "my_gem/version", for code coverage accuracy
# See: https://github.com/simplecov-ruby/simplecov/issues/557#issuecomment-825171399
load "lib/json_schemer/fuzz/version.rb"
gem_version = JSONSchemer::Fuzz::Version::VERSION
JSONSchemer::Fuzz::Version.send(:remove_const, :VERSION)

Gem::Specification.new do |spec|
  spec.name          = "json_schemer-fuzz"
  spec.version       = gem_version
  spec.authors       = ["Peter Boling", "deme0607"]
  spec.email         = ["peter.boling@gmail.com", "hcs0035@gmail.com"]
  spec.summary       = %q{Fuzz generator for json_schemer}
  spec.description   = %q{Fuzz generator for json_schemer}
  spec.homepage      = "https://github.com/pboling/json_schemer-fuzz"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "json_schemer", "~> 2.0"
  spec.add_dependency "randexp", "~> 0.1.7"

  spec.add_dependency "version_gem", "~> 1.1", ">= 1.1.3"

  spec.add_development_dependency "kettle-soup-cover", "~> 1.0", ">= 1.0.2"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-byebug"
end
