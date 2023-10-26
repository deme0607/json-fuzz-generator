module JSONSchemer
  module Fuzz
    class Keyword
      class Minimum
        class << self
          def invalid_params(attributes)
            minimum_value = attributes["minimum"]
            raise "No minimum keyword given: #{attributes}" unless minimum_value

            generated_params = []
            unit_value = (attributes.key?("type") && attributes["type"] == "integer") ? 1 : 0.1

            if attributes["exclusiveMinimum"]
              generated_params.push(minimum_value)
            else
              generated_params.push(minimum_value - unit_value)
            end

            generated_params
          end

          def valid_param(attributes)
            minimum_value = attributes["minimum"]
            raise "No minimum keyword given: #{attributes}" unless minimum_value

            unit_value = (attributes.key?("type") && attributes["type"] == "integer") ? 1 : 0.1
            minimum_value += unit_value if attributes["exclusiveMinimum"]

            if maximum_value = attributes["maximum"]
              if attributes["exclusiveMaximum"]
                Random.rand(minimum_value...maximum_value)
              else
                Random.rand(minimum_value..maximum_value)
              end
            else
              minimum_value
            end
          end
        end
      end
    end
  end
end
