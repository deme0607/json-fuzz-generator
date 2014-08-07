$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'fuzz-json-schema'
require 'pry'
require 'json-schema'

SPEC_ROOT        = File.expand_path(File.dirname(__FILE__), ".")
SPEC_SCHEMA_ROOT = File.join(SPEC_ROOT, "schemas")
