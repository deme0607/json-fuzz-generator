module Fuzz
  module JSON
    module Generator
      class PrimitiveType
        class String
          class << self
            def invalid_params(attributes)
              generated_params = []
              if type = attributes["type"]
                valid_types = [type].flatten
                Fuzz::JSON::Generator::PrimitiveType.invalid_params_by_type(attributes).each do |invalid_param|
                  generated_params.push(invalid_param)
                end
              else
                generated_params.push(1)
              end

              generated_params
            end

            def valid_param(attributes = {})
              "hoge"
            end
          end
        end
      end
    end
  end
end

