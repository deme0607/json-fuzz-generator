module JSONSchemer
  module Fuzz
    class PrimitiveType
      class Boolean
        class << self
          def invalid_params(attributes)
            generated_params = []

            if type = attributes["type"]
              valid_types = [type].flatten
              generated_params = ["true", "false", "1", "0"] unless valid_types.include?("string")
              JSONSchemer::Fuzz::PrimitiveType.invalid_params_by_type(attributes).each do |invalid_param|
                generated_params.push(invalid_param)
              end
            else
              generated_params = ["true", "false", "1", "0"]
            end

            generated_params
          end

          def valid_param(attributes = {})
            [true, false].sample
          end
        end
      end
    end
  end
end
