require_relative "primitive_type/array"
require_relative "primitive_type/boolean"
require_relative "primitive_type/integer"
require_relative "primitive_type/null"
require_relative "primitive_type/number"
require_relative "primitive_type/object"
require_relative "primitive_type/string"

module JSONSchemer
  module Fuzz
    class PrimitiveType
      class << self
        def invalid_params_by_type(attributes)
          type = attributes["type"]
          raise "No type given: #{attributes}" unless type

          valid_types = [type].flatten
          valid_types.push("integer") if valid_types.include?("number")

          invalid_params = []

          GENERATOR_MAP.each do |key, klass|
            invalid_params.push(klass.valid_param(attributes)) unless valid_types.include?(key)
          end

          invalid_params
        end
      end
    end
  end
end

