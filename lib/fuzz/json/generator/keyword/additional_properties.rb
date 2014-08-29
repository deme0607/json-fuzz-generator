module Fuzz
  module JSON
    module Generator
      class Keyword
        class AdditionalProperties
          class << self
            def invalid_params(attributes)
              attributes = Marshal.load(Marshal.dump(attributes))
              additional_properties = attributes.delete("additionalProperties")
              raise "No additionalProperties keyword given: #{attributes}" if additional_properties.nil?

              template = Fuzz::JSON::Generator.default_param(attributes)

              additional_key = nil
              until (additional_key)
                key = /\w+/.gen
                additional_key = key unless template.key?(key)
              end

              if additional_properties
                additional_param = Fuzz::JSON::Generator.generate(additional_properties).sample
                template[additional_key] = additional_param
              else
                template[additional_key] = template[template.keys.sample]
              end

              [template]
            end
            
            def valid_param(attributes)
              attributes = Marshal.load(Marshal.dump(attributes))
              additional_properties = attributes.delete("additionalProperties")
              raise "No additionalProperties keyword given: #{attributes}" if additional_properties.nil?

              template = Fuzz::JSON::Generator.default_param(attributes)

              if additional_properties
                additional_param = nil
                if additional_properties.instance_of?(Hash)
                  additional_param = Fuzz::JSON::Generator.default_param(additional_properties)
                else
                  additional_param = template[template.keys.sample]
                end

                additional_key = nil
                until (additional_key)
                  key = /\w+/.gen
                  additional_key = key unless template.key?(key)
                end

                template[additional_key] = additional_param
              end

              template
            end
          end
        end
      end
    end
  end
end
