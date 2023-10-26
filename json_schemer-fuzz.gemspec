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

  # See CONTRIBUTING.md
  spec.cert_chain = ["certs/pboling.pem"]
  spec.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $PROGRAM_NAME.end_with?("gem")

  spec.summary       = %q{Fuzz generator for json_schemer}
  spec.description   = %q{Fuzz generator for json_schemer}
  spec.homepage      = "https://github.com/pboling/json_schemer-fuzz"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/pboling/json_schemer-fuzz/tree/v#{spec.version}"
  spec.metadata["changelog_uri"] = "https://github.com/pboling/json_schemer-fuzz/blob/v#{spec.version}/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/pboling/json_schemer-fuzz/issues"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/json_schemer-fuzz/#{spec.version}"
  spec.metadata["wiki_uri"] = "https://github.com/pboling/json_schemer-fuzz/wiki"
  spec.metadata["funding_uri"] = "https://liberapay.com/pboling"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir[
    "lib/**/*.rb",
    "CHANGELOG.md",
    "CODE_OF_CONDUCT.md",
    "CONTRIBUTING.md",
    "LICENSE.txt",
    "README.md",
    "SECURITY.md"
  ]
  spec.bindir = "exe"
  spec.executables = []
  spec.require_paths = ["lib"]

  spec.add_dependency "json_schemer", "~> 2.0"
  spec.add_dependency "randexp", "~> 0.1.7"

  spec.add_dependency "version_gem", "~> 1.1", ">= 1.1.3"

  spec.add_development_dependency "kettle-soup-cover", "~> 1.0", ">= 1.0.2"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-byebug"
end
