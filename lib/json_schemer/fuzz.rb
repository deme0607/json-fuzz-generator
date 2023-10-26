# External gems
require "version_gem"
require "json_schemer"
require "randexp"

# This gem
require_relative "fuzz/version"
require_relative "fuzz/keyword"
require_relative "fuzz/primitive_type"

module JSONSchemer
  module Fuzz
    GENERATOR_MAP = {
      "array" => JSONSchemer::Fuzz::PrimitiveType::Array,
      "boolean" => JSONSchemer::Fuzz::PrimitiveType::Boolean,
      "integer" => JSONSchemer::Fuzz::PrimitiveType::Integer,
      "null" => JSONSchemer::Fuzz::PrimitiveType::Null,
      "number" => JSONSchemer::Fuzz::PrimitiveType::Number,
      "object" => JSONSchemer::Fuzz::PrimitiveType::Object,
      "string" => JSONSchemer::Fuzz::PrimitiveType::String,
    }.freeze

    extend self

    def generators(type)
      raise "no generator for #{type}" unless GENERATOR_MAP.key?(type)

      GENERATOR_MAP[type]
    end

    # Generate invalid data
    def generate(schema)
      schema = JSON.parse(open(schema).read) if schema.instance_of?(String)
      generated_params = []

      if (type = schema["type"])
        if type.instance_of?(Array) # union type
          all_types.each do |target_type|
            if type.include?(target_type)
              generators(target_type).invalid_params(schema).each do |invalid_param|
                generated_params.push(invalid_param)
              end
            else
              generated_params.push(generators(target_type).invalid_params("type" => target_type))
            end
          end
        elsif type == "any"
          # do nothing
        else
          generators(type).invalid_params(schema).each do |invalid_param|
            generated_params.push(invalid_param)
          end
        end
      elsif schema.key?("members") || schema.key?("properties")
        generators("object").invalid_params(schema).each do |invalid_param|
          generated_params.push(invalid_param)
        end
      elsif schema.empty?
        # do nothing
      elsif schema.key?("minimum") || schema.key?("maximum")
        generators("number").invalid_params(schema).each do |invalid_param|
          generated_params.push(invalid_param)
        end
      elsif schema.key?("minItems") || schema.key?("maxItems")
        generators("array").invalid_params(schema).each do |invalid_param|
          generated_params << invalid_param
        end
      elsif schema.key?("minProperties") || schema.key?("maxProperties")
        generators("object").invalid_params(schema).each do |invalid_param|
          generated_params << invalid_param
        end
      elsif schema.key?("uniqueItems")
        generators("array").invalid_params(schema).each do |invalid_param|
          generated_params << invalid_param
        end
      elsif schema.key?("pattern")
        generators("string").invalid_params(schema).each do |invalid_param|
          generated_params << invalid_param
        end
      elsif schema.key?("minLength") || schema.key?("maxLength")
        generators("string").invalid_params(schema).each do |invalid_param|
          generated_params << invalid_param
        end
      elsif schema.key?("enum")
        JSONSchemer::Fuzz::Keyword::Enum.invalid_params(schema).each do |invalid_param|
          generated_params << invalid_param
        end
      elsif schema.key?("multipleOf")
        generators("number").invalid_params(schema).each do |invalid_param|
          generated_params << invalid_param
        end
      elsif schema.key?("items")
        generators("array").invalid_params(schema).each do |invalid_param|
          generated_params << invalid_param
        end
      elsif schema.key?("$ref")
        raise "not impremented yet"
      elsif schema.key?("allOf") || schema.key?("anyOf") || schema.key?("oneOf")
        generators("object").invalid_params(schema).each do |invalid_param|
          generated_params << invalid_param
        end
      elsif schema.key?("not")
        JSONSchemer::Fuzz::Keyword::Not.invalid_params(schema).each do |invalid_param|
          generated_params << invalid_param
        end
      else
        raise "Not implemented generator for schema:#{schema}"
      end

      generated_params
    end

    # Generate valid data
    def default_param(schema)
      schema = JSON.parse(open(schema).read) if schema.instance_of?(String)

      if (type = schema["type"])
        type = type.sample if type.instance_of?(Array)
        type = all_types.sample if type == "any"
        generators(type).valid_param(schema)
      elsif schema.key?("properties")
        generators("object").valid_param(schema)
      elsif schema.empty?
        _, generator = JSONSchemer::Fuzz::GENERATOR_MAP.to_a.sample
        generator.valid_param
      elsif schema.key?("minimum") || schema.key?("maximum")
        generators("number").valid_param(schema)
      elsif schema.key?("minItems") || schema.key?("maxItems")
        generators("array").valid_param(schema)
      elsif schema.key?("minProperties") || schema.key?("maxProperties")
        generators("object").valid_param(schema)
      elsif schema.key?("uniqueItems")
        generators("array").valid_param(schema)
      elsif schema.key?("pattern")
        generators("string").valid_param(schema)
      elsif schema.key?("minLength") || schema.key?("maxLength")
        generators("string").valid_param(schema)
      elsif schema.key?("enum")
        JSONSchemer::Fuzz::Keyword::Enum.valid_param(schema)
      elsif schema.key?("multipleOf")
        generators("number").valid_param(schema)
      elsif schema.key?("items")
        generators("array").valid_param(schema)
      elsif schema.key?("$ref")
        raise "not impremented yet"
      elsif schema.key?("allOf")
        JSONSchemer::Fuzz::Keyword::AllOf.valid_param(schema)
      elsif schema.key?("anyOf")
        JSONSchemer::Fuzz::Keyword::AnyOf.valid_param(schema)
      elsif schema.key?("oneOf")
        JSONSchemer::Fuzz::Keyword::OneOf.valid_param(schema)
      elsif schema.key?("not")
        JSONSchemer::Fuzz::Keyword::Not.valid_param(schema)
      else
        raise "Not implemented generator for schema:#{schema}"
      end
    end

    private

    def all_types
      %w[array boolean integer null number object string]
    end
  end
end

JSONSchemer::Fuzz::Version.class_eval do
  extend VersionGem::Basic
end
