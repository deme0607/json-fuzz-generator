module Fuzz
  module JSON
    class Generator
      class PrimitiveType
        class Number
          def invalid_params(attributes, generator)
            ["0.1", "10", "hoge"]
          end

          def valid_param(attributes, generator)
            rand
          end
        end
      end
    end
  end
end

