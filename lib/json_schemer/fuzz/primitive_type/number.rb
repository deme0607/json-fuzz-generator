module JSONSchemer
  module Fuzz
    class PrimitiveType
      class Number
        class << self
          def invalid_params(attributes)
            generated_params = []
            if type = attributes["type"]
              valid_types = [type].flatten
              generated_params = ["0.1", "10", "hoge"] unless valid_types.include?("string")
              JSONSchemer::Fuzz::PrimitiveType.invalid_params_by_type(attributes).each do |invalid_param|
                generated_params << invalid_param
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
                valid_params << klass.valid_param(attributes).to_f
              end
            end

            valid_params.empty? ? rand : valid_params.sample
          end

          def keyword_to_class_map
            {
              "minimum"    => JSONSchemer::Fuzz::Keyword::Minimum,
              "maximum"    => JSONSchemer::Fuzz::Keyword::Maximum,
              "multipleOf" => JSONSchemer::Fuzz::Keyword::MultipleOf,
            }
          end
        end
      end
    end
  end
end
