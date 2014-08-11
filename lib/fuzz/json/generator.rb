module Fuzz
  module JSON
    module Generator
      extend self
      def generators(type)
        generator_map = {
          "array"   => Fuzz::JSON::Generator::PrimitiveType::Array,
          "boolean" => Fuzz::JSON::Generator::PrimitiveType::Boolean,
          "integer" => Fuzz::JSON::Generator::PrimitiveType::Integer,
          "null"    => Fuzz::JSON::Generator::PrimitiveType::Null,
          "number"  => Fuzz::JSON::Generator::PrimitiveType::Number,
          "object"  => Fuzz::JSON::Generator::PrimitiveType::Object,
          "string"  => Fuzz::JSON::Generator::PrimitiveType::String,
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
        elsif schema.key?("properties")
          generators("object").invalid_params(schema).each do |invalid_param|
            generated_params.push(invalid_param)
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
          type = %w[array boolean integer null number object string].sample if type == "any"
          generated_param = generators(type).valid_param(schema)
        elsif schema.key?("properties")
          generated_param = generators("object").valid_param(schema)
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
