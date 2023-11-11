module JSONSchemer
  module Fuzz
    class PrimitiveType
      class String
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

            generated_params.empty? ? [1] : generated_params
          end

          def valid_param(attributes = {})
            generated_params = []

            attributes.each do |keyword, attribute|
              if klass = keyword_to_class_map[keyword]
                generated_params << klass.valid_param(attributes)
              end
            end

            generated_params.empty? ? "hoge" : generated_params.sample
          end

          def keyword_to_class_map
            {
              "pattern" => JSONSchemer::Fuzz::Keyword::Pattern,
              "minLength" => JSONSchemer::Fuzz::Keyword::MinLength,
              "maxLength" => JSONSchemer::Fuzz::Keyword::MaxLength,
              "format" => JSONSchemer::Fuzz::Keyword::Format,
            }
          end
        end
      end
    end
  end
end
