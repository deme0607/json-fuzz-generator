module JSON
  module Fuzz
    module Generator
      Dir[File.join(File.dirname(__FILE__), "generator/*.rb")].each {|file| require file }

      extend self
      def generators(type)
        generator_map = {
          "array"   => JSON::Fuzz::Generator::PrimitiveType::Array,
          "boolean" => JSON::Fuzz::Generator::PrimitiveType::Boolean,
          "integer" => JSON::Fuzz::Generator::PrimitiveType::Integer,
          "null"    => JSON::Fuzz::Generator::PrimitiveType::Null,
          "number"  => JSON::Fuzz::Generator::PrimitiveType::Number,
          "object"  => JSON::Fuzz::Generator::PrimitiveType::Object,
          "string"  => JSON::Fuzz::Generator::PrimitiveType::String,
        }

        if generator_map.key?(type)
          return generator_map[type]
        else
          raise "no generator for #{type}"
        end
  j   end

      def generate(schema)
        schema = ::JSON::Validator.parse(open(schema).read) if schema.instance_of?(String)
        generated_params = []

        if type = schema["type"]
          if type.instance_of?(Array) # union type
            all_types.each do |target_type|
              if type.include?(target_type)
                generators(target_type).invalid_params(schema).each do |invalid_param|
                  generated_params.push(invalid_param)
                end
              else
                generated_params.push(generators(target_type).valid_param("type" => target_type))
              end
            end
          elsif type == "any"
            # do nothing
          else
            generators(type).invalid_params(schema).each do |invalid_param|
              generated_params.push(invalid_param)
            end
          end
        elsif (schema.key?("members") || schema.key?("properties"))
          generators("object").invalid_params(schema).each do |invalid_param|
            generated_params.push(invalid_param)
          end
        elsif schema.empty?
          # do nothing
        elsif (schema.key?("minimum") || schema.key?("maximum"))
          generators("number").invalid_params(schema).each do |invalid_param|
            generated_params.push(invalid_param)
          end
        elsif (schema.key?("minItems") || schema.key?("maxItems"))
          generators("array").invalid_params(schema).each do |invalid_param|
            generated_params << invalid_param
          end
        elsif (schema.key?("minProperties") || schema.key?("maxProperties"))
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
        elsif (schema.key?("minLength") || schema.key?("maxLength"))
          generators("string").invalid_params(schema).each do |invalid_param|
            generated_params << invalid_param
          end
        elsif schema.key?("enum")
          JSON::Fuzz::Generator::Keyword::Enum.invalid_params(schema).each do |invalid_param|
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
        elsif (schema.key?("allOf") || schema.key?("anyOf") || schema.key?("oneOf"))
          generators("object").invalid_params(schema).each do |invalid_param|
            generated_params << invalid_param
          end
        elsif schema.key?("not")
          JSON::Fuzz::Generator::Keyword::Not.invalid_params(schema).each do |invalid_param|
            generated_params << invalid_param
          end
        else
          raise "Not impremented generator for schema:#{schema}"
        end

        generated_params
      end

      def default_param(schema)
        schema = ::JSON::Validator.parse(open(schema).read) if schema.instance_of?(String)
        generated_param = nil;

        if type = schema["type"]
          type = type.sample if type.instance_of?(Array)
          type = all_types.sample if type == "any"
          generated_param = generators(type).valid_param(schema)
        elsif schema.key?("properties")
          generated_param = generators("object").valid_param(schema)
        elsif schema.empty?
          type, generator = JSON::Fuzz::Generator::PrimitiveType.type_to_class_map.to_a.sample
          generated_param = generator.valid_param
        elsif (schema.key?("minimum") || schema.key?("maximum"))
          generated_param = generators("number").valid_param(schema)
        elsif (schema.key?("minItems") || schema.key?("maxItems"))
          generated_param = generators("array").valid_param(schema)
        elsif (schema.key?("minProperties") || schema.key?("maxProperties"))
          generated_param = generators("object").valid_param(schema)
        elsif schema.key?("uniqueItems")
          generated_param = generators("array").valid_param(schema)
        elsif schema.key?("pattern")
          generated_param = generators("string").valid_param(schema)
        elsif (schema.key?("minLength") || schema.key?("maxLength"))
          generated_param = generators("string").valid_param(schema)
        elsif schema.key?("enum")
          generated_param = JSON::Fuzz::Generator::Keyword::Enum.valid_param(schema)
        elsif schema.key?("multipleOf")
          generated_param = generators("number").valid_param(schema)
        elsif schema.key?("items")
          generated_param = generators("array").valid_param(schema)
        elsif schema.key?("$ref")
          raise "not impremented yet"
        elsif schema.key?("allOf")
          generated_param = JSON::Fuzz::Generator::Keyword::AllOf.valid_param(schema)
        elsif schema.key?("anyOf")
          generated_param = JSON::Fuzz::Generator::Keyword::AnyOf.valid_param(schema)
        elsif schema.key?("oneOf")
          generated_param = JSON::Fuzz::Generator::Keyword::OneOf.valid_param(schema)
        elsif schema.key?("not")
          generated_param = JSON::Fuzz::Generator::Keyword::Not.valid_param(schema)
        else
          raise "Not impremented generator for schema:#{schema}"
        end

        generated_param
      end

      private
      def all_types
        %w[array boolean integer null number object string]
      end
    end
  end
end
