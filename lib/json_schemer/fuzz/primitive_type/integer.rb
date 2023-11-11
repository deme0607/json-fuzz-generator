module JSONSchemer
  module Fuzz
    class PrimitiveType
      class Integer
        class << self
          def invalid_params(attributes)
            generated_params = []
            if type = attributes["type"]
              valid_types = [type].flatten
              # TODO: Ideally this array would include a string number, as that is the intent here
              ["&"].each { |val| generated_params << val } unless valid_types.include?("string")
              # TODO: Ideally 0.1 would work here as invalid, as it is not an integer
              #       But it doesn't, so instead we use an array
              generated_params << [0.1] unless valid_types.include?("number")
              JSONSchemer::Fuzz::PrimitiveType.invalid_params_by_type(attributes).each do |invalid_param|
                generated_params << invalid_param
              end
            else
              generated_params = ["#"]
            end

            attributes.each do |keyword, attribute|
              if (klass = keyword_to_class_map[keyword])
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

            valid_params.empty? ? rand(100) : valid_params.sample
          end

          def keyword_to_class_map
            {
              "minimum" => JSONSchemer::Fuzz::Keyword::Minimum,
              "maximum" => JSONSchemer::Fuzz::Keyword::Maximum,
              "multipleOf" => JSONSchemer::Fuzz::Keyword::MultipleOf,
            }
          end
        end
      end
    end
  end
end
