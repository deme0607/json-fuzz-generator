module Fuzz
  module JSON
    class Generator
      class PrimitiveType
        class Array
          def invalid_params(attributes, generator)
            [{}]
          end

          def valid_param(attributes, generator)
            ["sample", "array"]
          end
        end
      end
    end
  end
end

