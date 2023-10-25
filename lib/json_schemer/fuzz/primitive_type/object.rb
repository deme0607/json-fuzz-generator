module JSONSchemer
  module Fuzz
    class PrimitiveType
      class Object
        class << self
          def invalid_params(attributes)
            generated_params = []

            if type = attributes["type"]
              valid_types = [type].flatten
              JSONSchemer::Fuzz::PrimitiveType.invalid_params_by_type(attributes).each do |invalid_param|
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
              "members"              => JSONSchemer::Fuzz::Keyword::Properties,
              "properties"           => JSONSchemer::Fuzz::Keyword::Properties,
              "required"             => JSONSchemer::Fuzz::Keyword::Required,
              "minProperties"        => JSONSchemer::Fuzz::Keyword::MinProperties,
              "maxProperties"        => JSONSchemer::Fuzz::Keyword::MaxProperties,
              "additionalProperties" => JSONSchemer::Fuzz::Keyword::AdditionalProperties,
              "dependencies"         => JSONSchemer::Fuzz::Keyword::Dependencies,
            }
          end
        end
      end
    end
  end
end
