module Fuzz
  module JSON
    module Generator
      class PrimitiveType
        class Array
          class << self
            def invalid_params(attributes)
              generated_params = []

              if type = attributes["type"]
                Fuzz::JSON::Generator::PrimitiveType.invalid_params_by_type(attributes).each do |invalid_param|
                  generated_params.push(invalid_param)
                end
              else
                generated_params.push({})
              end
              
              generated_params
            end

            def valid_param(attributes = {})
              ["sample", "array"]
            end
          end
        end
      end
    end
  end
end

