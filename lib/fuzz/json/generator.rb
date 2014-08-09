module Fuzz
  module JSON
    class Generator
      class << self
        def generate(json_schema)
          generator = Fuzz::JSON::Generator.new
          generator.generate(json_schema)
        end
      end

      attr_accessor :generators

      def initialize
        @generators = {
          "array"   => Fuzz::JSON::Generator::PrimitiveType::Array.new,
          "boolean" => Fuzz::JSON::Generator::PrimitiveType::Boolean.new,
          "integer" => Fuzz::JSON::Generator::PrimitiveType::Integer.new,
          "null"    => Fuzz::JSON::Generator::PrimitiveType::Null.new,
          "number"  => Fuzz::JSON::Generator::PrimitiveType::Number.new,
          "object"  => Fuzz::JSON::Generator::PrimitiveType::Object.new,
          "string"  => Fuzz::JSON::Generator::PrimitiveType::String.new,
        }
      end

      def generate(schema)
        schema = ::JSON::Validator.parse(open(schema).read) if schema.instance_of?(String)
        generated_params = []

        if type = schema["type"]
          raise "No generator type for #{type}" unless @generators.key?(type)
          @generators[type].invalid_params(schema, self).each do |invalid_param|
            generated_params.push(invalid_param)
          end
        elsif schema.key?("properties")
          type = "object"
          @generators[type].invalid_params(schema, self).each do |invalid_param|
            generated_params.push(invalid_param)
          end
        else
          raise "Not impremented generator for schema:#{schema}"
        end

        generated_params
      end

      def default_param(schema)
        generated_param = nil;
        schema = ::JSON::Validator.parse(open(schema).read) if schema.instance_of?(String)

        if type = schema["type"]
          raise "No generator type for #{type}" unless @generators.key?(type)
          generated_param = @generators[type].valid_param(schema, self)
        elsif schema.key?("properties")
          type = "object"
          generated_param = @generators[type].valid_param(schema, self)
        else
          raise "Not impremented generator for schema:#{schema}"
        end

        generated_param
      end
    end
  end
end
