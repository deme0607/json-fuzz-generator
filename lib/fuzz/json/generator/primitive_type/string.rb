module Fuzz
  module JSON
    class Generator
      class PrimitiveType
        class String
          def invalid_params(attributes, generator)
            [1]
          end

          def valid_param(attributes, generator)
            "hoge"
          end
        end
      end
    end
  end
end

