Dir[File.join(File.dirname(__FILE__), "primitive_type/*.rb")].each {|file| require file }

module Fuzz
  module JSON
    module Generator
      class PrimitiveType
        class << self
          def type_to_class_map
            {
              "array"   => Fuzz::JSON::Generator::PrimitiveType::Array,
              "boolean" => Fuzz::JSON::Generator::PrimitiveType::Boolean,
              "integer" => Fuzz::JSON::Generator::PrimitiveType::Integer,
              "null"    => Fuzz::JSON::Generator::PrimitiveType::Null,
              "number"  => Fuzz::JSON::Generator::PrimitiveType::Number,
              "object"  => Fuzz::JSON::Generator::PrimitiveType::Object,
              "string"  => Fuzz::JSON::Generator::PrimitiveType::String,
            }
          end

          def invalid_params_by_type(attributes)
            type = attributes["type"]
            raise "No type given: #{attributes}" unless type

            valid_types = [type].flatten
            valid_types.push("integer") if valid_types.include?("number")

            invalid_params = []

            type_to_class_map.each do |key, klass|
              invalid_params.push(klass.valid_param(attributes)) unless valid_types.include?(key)
            end

            invalid_params
          end
        end
      end
    end
  end
end

