module JSON
  module Fuzz
    module Generator
      class PrimitiveType
        Dir[File.join(File.dirname(__FILE__), "primitive_type/*.rb")].each {|file| require file }

        class << self
          def type_to_class_map
            {
              "array"   => JSON::Fuzz::Generator::PrimitiveType::Array,
              "boolean" => JSON::Fuzz::Generator::PrimitiveType::Boolean,
              "integer" => JSON::Fuzz::Generator::PrimitiveType::Integer,
              "null"    => JSON::Fuzz::Generator::PrimitiveType::Null,
              "number"  => JSON::Fuzz::Generator::PrimitiveType::Number,
              "object"  => JSON::Fuzz::Generator::PrimitiveType::Object,
              "string"  => JSON::Fuzz::Generator::PrimitiveType::String,
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

