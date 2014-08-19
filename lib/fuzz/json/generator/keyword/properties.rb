module Fuzz
  module JSON
    module Generator
      class Keyword
        class Properties
          class << self
            def invalid_params(attributes)
              properties = attributes["members"] || attributes["properties"]
              raise "No properties or members keyword given: #{attributes}" unless properties

              generated_params = []

              properties.each do |key, attribute|
                Fuzz::JSON::Generator.generate(attribute).each do |invalid_param|
                  template = Fuzz::JSON::Generator.default_param(attributes)
                  generated_params << template.merge(key => invalid_param)
                end
              end

              generated_params
            end

            def valid_param(attributes)
              #attributes = Marshal.load(Marshal.dump(attributes))
              #properties = attributes.delete("members") || attributes.delete("properties")
              properties = attributes["members"] || attributes["properties"]
              raise "No properties or members keyword given: #{attributes}" unless properties

              generated_param = {}

              properties.each do |key, attribute|
                generated_param[key] = Fuzz::JSON::Generator.default_param(attribute)
              end

              generated_param
            end
          end
        end
      end
    end
  end
end
