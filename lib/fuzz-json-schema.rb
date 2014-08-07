require "json-schema"
require "fuzz/json/schema"
require "fuzz/json/generator"

Dir[File.join(File.dirname(__FILE__), "fuzz/json/generator/*.rb")].each {|file| require file }
