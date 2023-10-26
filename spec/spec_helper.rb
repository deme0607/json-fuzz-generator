# External gems
require 'json_schemer'
require 'pry'
require 'byebug'
# This does not require "simplecov",
#   because that has a side-effect of running `.simplecov`
require "kettle-soup-cover"

require "simplecov" if Kettle::Soup::Cover::DO_COV

# This gem
require 'json_schemer-fuzz'

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
