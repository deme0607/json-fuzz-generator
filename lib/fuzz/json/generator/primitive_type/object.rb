module Fuzz
  module JSON
    class Generator
      class PrimitiveType
        class Object
          def invalid_params(attributes, generator)
            generated_params = []

            if (attributes.key?("members") || attributes.key?("properties"))
              properties = attributes["members"] || attributes["properties"]
              properties.each do |key, attribute|
                generator.generate(attribute).each do |invalid_param|
                  template = generator.default_param(attributes)
                  generated_params.push(template.merge(key => invalid_param))
                end
              end
            else
              generated_params = [nil, []]
            end

            generated_params
          end

          def valid_param(attributes, generator)
            generated_param = {}

            if (attributes.key?("members") || attributes.key?("properties"))
              properties = attributes["members"] || attributes["properties"]

              properties.each do |key, attribute|
                generated_param[key] = generator.default_param(attribute)
              end
            end

            generated_param
          end
        end
      end
    end
  end
end

