module JSONSchemer
  module Fuzz
    class Keyword
      class Maximum
        class << self
          def invalid_params(attributes)
            maximum_value = attributes["maximum"]
            raise "No maximum keyword given: #{attributes}" unless maximum_value

            generated_params = []
            unit_value = (attributes.key?("type") && attributes["type"] == "integer") ? 1 : 0.1

            if attributes["exclusiveMaximum"]
              generated_params.push(maximum_value)
            else
              generated_params.push(maximum_value + unit_value)
            end

            return generated_params
          end

          def valid_param(attributes)
            maximum_value = attributes["maximum"]
            raise "No maximum keyword given: #{attributes}" unless maximum_value

            unit_value = (attributes.key?("type") && attributes["type"] == "integer") ? 1 : 0.1
            maximum_value -= unit_value if attributes["exclusiveMaximum"]

            if minimum_value = attributes["minimum"]
              minimum_value += unit_value if attributes["exclusiveMinimum"]
              if attributes["exclusiveMaximum"]
                return Random.rand(minimum_value...maximum_value)
              else
                return Random.rand(minimum_value..maximum_value)
              end
            else
              return maximum_value
            end
          end
        end
      end
    end
  end
end
