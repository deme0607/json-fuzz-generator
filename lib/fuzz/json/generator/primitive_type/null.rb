module Fuzz
  module JSON
    class Generator
      class PrimitiveType
        class Null
          def invalid_params(attributes, generator)
            ["nil", "0", "null", false, ""]
          end

          def valid_param(attributes, generator)
            nil
          end
        end
      end
    end
  end
end

