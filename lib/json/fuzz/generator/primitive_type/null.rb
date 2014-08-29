module JSON
  module Fuzz
    module Generator
      class PrimitiveType
        class Null
          class << self
            def invalid_params(attributes)
              generated_params = []
              if type = attributes["type"]
                valid_types = [type].flatten
                generated_params = ["nil", "0", "null", ""] unless valid_types.include?("string")
                generated_params.push(false) unless valid_types.include?("boolean")

                JSON::Fuzz::Generator::PrimitiveType.invalid_params_by_type(attributes).each do |invalid_param|
                  generated_params.push(invalid_param)
                end
              else
                generated_params = ["nil", "0", "null", false, ""]
              end

              generated_params
            end

            def valid_param(attributes = {})
              nil
            end
          end
        end
      end
    end
  end
end

