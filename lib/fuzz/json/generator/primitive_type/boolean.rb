module Fuzz
  module JSON
    class Generator
      class PrimitiveType
        class Boolean
          def invalid_params(attributes, generator)
            ["true", "false", "1", "0"]
          end

          def valid_param(attributes, generator)
            [true, false].sample
          end
        end
      end
    end
  end
end

