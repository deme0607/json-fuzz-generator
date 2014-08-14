module Fuzz
  module JSON
    module Generator
      class PrimitiveType
        class Integer
          class << self
            def invalid_params(attributes)
              generated_params = []
              if type = attributes["type"]
                valid_types = [type].flatten
                ["a", "1"].each {|val| generated_params << val} unless valid_types.include?("string")
                generated_params << 0.1 unless valid_types.include?("number")
                Fuzz::JSON::Generator::PrimitiveType.invalid_params_by_type(attributes).each do |invalid_param|
                  generated_params << invalid_param
                end
              else
                #generated_params = ["a", "1"]
              end

              attributes.each do |keyword, attribute|
                if klass = Fuzz::JSON::Generator::Keyword.keyword_to_class_map[keyword]
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
                if klass = Fuzz::JSON::Generator::Keyword.keyword_to_class_map[keyword]
                  valid_params << klass.valid_param(attributes)
                end
              end

              valid_params.empty? ? rand(100) : valid_params.sample
            end
          end
        end
      end
    end
  end
end

