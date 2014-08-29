module JSON
  module Fuzz
    module Generator
      class PrimitiveType
        class String
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
                "pattern"   => JSON::Fuzz::Generator::Keyword::Pattern,
                "minLength" => JSON::Fuzz::Generator::Keyword::MinLength,
                "maxLength" => JSON::Fuzz::Generator::Keyword::MaxLength,
                "format"    => JSON::Fuzz::Generator::Keyword::Format,
              }
            end
          end
        end
      end
    end
  end
end

