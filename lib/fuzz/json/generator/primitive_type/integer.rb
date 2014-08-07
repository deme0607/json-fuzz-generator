module Fuzz
  module JSON
    class Generator
      class PrimitiveType
        class Integer
          def invalid_params(attributes, generator)
            ["a", "1"]
          end

          def valid_param(attributes, generator)
            rand(100)
          end
        end
      end
    end
  end
end

