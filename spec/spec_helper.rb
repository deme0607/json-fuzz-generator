$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'fuzz-json-schema'
require 'pry'
require 'json-schema'

SPEC_ROOT        = File.expand_path(File.dirname(__FILE__), ".")
SPEC_SCHEMA_ROOT = File.join(SPEC_ROOT, "schemas")

RSpec::Matchers.define :be_matching_schema do |schema|
  match do |actual|
    JSON::Validator.validate(schema, actual) == true
  end
  failure_message do |actual|
    "expected #{actual} to be match schema: #{schema}"
  end
end

RSpec::Matchers.define :be_not_matching_schema do |expected|
  match do |actual|
    JSON::Validator.validate(schema, actual) == false
  end
  failure_message do |actual|
    "expected #{actual} not to be match schema: #{schema}"
  end
end
