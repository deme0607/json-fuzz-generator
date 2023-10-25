module JSONSchemer
  module Fuzz
    class Keyword
      class MinProperties
        class << self
          def invalid_params(attributes)
            min_properties = attributes["minProperties"]
            raise "No minProperties keyword given: #{attributes}" unless min_properties

            generated_params = []
            invalid_param = {}

            template = valid_param(attributes)
            template.delete(template.keys.sample)

            [template]
          end

          def valid_param(attributes)
            attributes = Marshal.load(Marshal.dump(attributes))
            min_properties = attributes.delete("minProperties")
            raise "No minProperties keyword given: #{attributes}" unless min_properties

            template = JSONSchemer::Fuzz.default_param(attributes)

            while template.size < min_properties
              key = /\w+/.gen
              template[key] = template[template.keys.sample]
            end

            template
          end
        end
      end
    end
  end
end
