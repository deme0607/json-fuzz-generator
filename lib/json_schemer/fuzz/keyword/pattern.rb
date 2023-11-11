module JSONSchemer
  module Fuzz
    class Keyword
      class Pattern
        class << self
          def invalid_params(attributes)
            raise "not implemented"
          end

          def valid_param(attributes)
            raise "not implemented"
          end
        end
      end
    end
  end
end
