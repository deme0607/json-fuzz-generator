module JSON
  module Fuzz
    module Generator
      class PrimitiveType
        class Object
          class << self
            def invalid_params(attributes)
              generated_params = []

              if type = attributes["type"]
                valid_types = [type].flatten
                JSON::Fuzz::Generator::PrimitiveType.invalid_params_by_type(attributes).each do |invalid_param|
                  generated_params.push(invalid_param)
                end
              end

              attributes.each do |keyword, attribute|
                if klass = keyword_to_class_map[keyword]
                  klass.invalid_params(attributes).each do |invalid_param|
                    generated_params << invalid_param
                  end
                end
              end

              generated_params
            end

            def valid_param(attributes = {})
              generated_params = {}

              attributes.each do |keyword, attribute|
                if klass = keyword_to_class_map[keyword]
                  generated_params.merge!(klass.valid_param(attributes))
                end
              end

              generated_params
            end

            def keyword_to_class_map
              {
                "members"              => JSON::Fuzz::Generator::Keyword::Properties,
                "properties"           => JSON::Fuzz::Generator::Keyword::Properties,
                "required"             => JSON::Fuzz::Generator::Keyword::Required,
                "minProperties"        => JSON::Fuzz::Generator::Keyword::MinProperties,
                "maxProperties"        => JSON::Fuzz::Generator::Keyword::MaxProperties,
                "additionalProperties" => JSON::Fuzz::Generator::Keyword::AdditionalProperties,
                "dependencies"         => JSON::Fuzz::Generator::Keyword::Dependencies,
              }
            end
          end
        end
      end
    end
  end
end

