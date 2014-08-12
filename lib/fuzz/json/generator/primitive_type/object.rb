module Fuzz
  module JSON
    module Generator
      class PrimitiveType
        class Object
          class << self
            def invalid_params(attributes)
              generated_params = []

              if (attributes.key?("members") || attributes.key?("properties"))
                properties = attributes["members"] || attributes["properties"]
                properties.each do |key, attribute|
                  Fuzz::JSON::Generator.generate(attribute).each do |invalid_param|
                    template = Fuzz::JSON::Generator.default_param(attributes)
                    generated_params.push(template.merge(key => invalid_param))
                  end
                end
              end

              if type = attributes["type"]
                valid_types = [type].flatten
                Fuzz::JSON::Generator::PrimitiveType.invalid_params_by_type(attributes).each do |invalid_param|
                  generated_params.push(invalid_param)
                end
              end

              if required_properties = attributes["required"]
                required_properties.each do |property|
                  template = Fuzz::JSON::Generator.default_param(attributes)
                  generated_params.push(template.delete(property))
                end
              end

              generated_params
            end

            def valid_param(attributes = {})
              generated_param = {}

              if (attributes.key?("members") || attributes.key?("properties"))
                properties = attributes["members"] || attributes["properties"]

                properties.each do |key, attribute|
                  generated_param[key] = Fuzz::JSON::Generator.default_param(attribute)
                end
              end

              generated_param
            end
          end
        end
      end
    end
  end
end

