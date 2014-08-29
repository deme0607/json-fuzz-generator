module Fuzz
  module JSON
    module Generator
      class PrimitiveType
        class Object
          class << self
            def invalid_params(attributes)
              generated_params = []

              if type = attributes["type"]
                valid_types = [type].flatten
                Fuzz::JSON::Generator::PrimitiveType.invalid_params_by_type(attributes).each do |invalid_param|
                  generated_params.push(invalid_param)
                end
              end

              attributes.each do |keyword, attribute|
                #if klass = Fuzz::JSON::Generator::Keyword.keyword_to_class_map[keyword]
                if klass = keyword_to_class_map[keyword]
                  klass.invalid_params(attributes).each do |invalid_param|
                    generated_params << invalid_param
                  end
                end
              end

              generated_params
            end

            def valid_param(attributes = {})
              #generated_params = []
              generated_params = {}

              attributes.each do |keyword, attribute|
                #if klass = Fuzz::JSON::Generator::Keyword.keyword_to_class_map[keyword]
                if klass = keyword_to_class_map[keyword]
                  #generated_params << klass.valid_param(attributes)
                  generated_params.merge!(klass.valid_param(attributes))
                end
              end

              #generated_params.empty? ? {} : generated_params.sample
              generated_params
            end

            def keyword_to_class_map
              {
                "members"       => Fuzz::JSON::Generator::Keyword::Properties,
                "properties"    => Fuzz::JSON::Generator::Keyword::Properties,
                "required"      => Fuzz::JSON::Generator::Keyword::Required,
                "minProperties" => Fuzz::JSON::Generator::Keyword::MinProperties,
                "maxProperties" => Fuzz::JSON::Generator::Keyword::MaxProperties,
                "additionalProperties" => Fuzz::JSON::Generator::Keyword::AdditionalProperties,
                "dependencies"  => Fuzz::JSON::Generator::Keyword::Dependencies,
              }
            end
          end
        end
      end
    end
  end
end

