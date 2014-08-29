module JSON
  module Fuzz
    module Generator
      class Keyword
        class Pattern 
          class << self
            def invalid_params(attributes)
              raise "not impremented"
            end

            def valid_param(attributes)
              raise "not impremented"
            end
          end
        end
      end
    end
  end
end
