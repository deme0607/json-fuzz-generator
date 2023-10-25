# External gems
require 'json_schemer'
require 'pry'
require 'byebug'

# This gem
require 'json_schemer-fuzz'

SPEC_ROOT        = File.expand_path(File.dirname(__FILE__), ".")
SPEC_SCHEMA_ROOT = File.join(SPEC_ROOT, "schemas")

RSpec::Matchers.define :be_matching_schema do |schema|
  match do |actual|
    schemer = JSONSchemer.schema(schema)
    # byebug if schemer.valid?(actual) == false
    schemer.valid?(actual) == true
  end
  failure_message do |actual|
    "expected #{actual} to be match schema: #{schema}"
  end
end

RSpec::Matchers.define :be_not_matching_schema do |expected|
  match do |actual|
    schemer = JSONSchemer.schema(schema)
    schemer.valid?(actual) == false
  end
  failure_message do |actual|
    "expected #{actual} not to be match schema: #{schema}"
  end
end
