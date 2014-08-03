module Fuzz
  module JSON
    class Generator
      class PropertiesAttribute
        def generate(attributes, generator)
          generated_params = []
          attribute = attributes["properties"]

          attribute.each do |key, properties|
            properties.each do |property_name, property|
              if generator.generators.key?(property_name)
                invalid_params = generator.generators[property_name].generate(properties, generator)
                if invalid_params
                  invalid_params.each { |param| generated_params.push( {key => param} ) }
                end
              end
            end
          end

          generated_params
        end
      end
    end
  end
end
