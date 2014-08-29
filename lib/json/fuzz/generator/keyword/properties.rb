module JSON
  module Fuzz
    module Generator
      class Keyword
        class Properties
          class << self
            def invalid_params(attributes)
              properties = attributes["members"] || attributes["properties"]
              raise "No properties or members keyword given: #{attributes}" unless properties

              generated_params = []

              properties.each do |key, attribute|
                JSON::Fuzz::Generator.generate(attribute).each do |invalid_param|
                  template = JSON::Fuzz::Generator.default_param(attributes)
                  generated_params << template.merge(key => invalid_param)
                end
              end

              generated_params
            end

            def valid_param(attributes)
              properties = attributes["members"] || attributes["properties"]
              raise "No properties or members keyword given: #{attributes}" unless properties

              generated_param = {}

              properties.each do |key, attribute|
                generated_param[key] = JSON::Fuzz::Generator.default_param(attribute)
              end

              generated_param
            end
          end
        end
      end
    end
  end
end
