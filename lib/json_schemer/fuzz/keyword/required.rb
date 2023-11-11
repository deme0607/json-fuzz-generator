module JSONSchemer
  module Fuzz
    class Keyword
      class Required
        class << self
          def invalid_params(attributes)
            required_properties = attributes["required"]
            raise "No required keyword given: #{attributes}" unless required_properties

            generated_params = []

            required_properties.each do |property|
              template = JSONSchemer::Fuzz.default_param(attributes)
              template.delete(property)
              generated_params << template
            end

            generated_params
          end

          def valid_param(attributes)
            required_properties = attributes["required"]
            raise "No required keyword given: #{attributes}" unless required_properties

            generated_param = {}

            required_properties.each do |property|
              properties_key = attributes.key?("members") ? "members" : "properties"
              attribute = attributes[properties_key][property]
              generated_param[property] = JSONSchemer::Fuzz.default_param(attribute)
            end

            generated_param
          end
        end
      end
    end
  end
end
