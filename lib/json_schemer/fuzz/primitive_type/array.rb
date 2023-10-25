module JSONSchemer
  module Fuzz
    class PrimitiveType
      class Array
        class << self
          def invalid_params(attributes)
            generated_params = []

            if type = attributes["type"]
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
            valid_params = []

            attributes.each do |keyword, attribute|
              if klass = keyword_to_class_map[keyword]
                valid_params << klass.valid_param(attributes)
              end
            end

            valid_params.empty? ? ["sample", "array"] : valid_params.sample
          end

          def keyword_to_class_map
            {
              "minItems"    => JSONSchemer::Fuzz::Keyword::MinItems,
              "maxItems"    => JSONSchemer::Fuzz::Keyword::MaxItems,
              "uniqueItems" => JSONSchemer::Fuzz::Keyword::UniqueItems,
              "items"       => JSONSchemer::Fuzz::Keyword::Items,
            }
          end
        end
      end
    end
  end
end

