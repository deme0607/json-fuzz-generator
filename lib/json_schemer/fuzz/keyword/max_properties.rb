module JSONSchemer
  module Fuzz
    class Keyword
      class MaxProperties
        class << self
          # @return Array
          def invalid_params(attributes)
            max_properties = attributes["maxProperties"]
            raise "No maxProperties keyword given: #{attributes}" unless max_properties

            generated_params = []
            invalid_param = {}

            template = valid_param(attributes)

            while template.size <= max_properties
              key = /\w+/.gen
              template[key] = template[template.keys.sample]
            end

            [template]
          end

          def valid_param(attributes)
            attributes = Marshal.load(Marshal.dump(attributes))
            max_properties = attributes.delete("maxProperties")
            raise "No maxProperties keyword given: #{attributes}" unless max_properties

            template = JSONSchemer::Fuzz.default_param(attributes)

            while template.size > max_properties
              requred_keys = attributes["required"] || []
              key = (template.keys - requred_keys).sample
              template.delete(template.keys.sample)
            end

            template
          end
        end
      end
    end
  end
end
