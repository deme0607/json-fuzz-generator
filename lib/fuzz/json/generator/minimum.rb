module Fuzz
  module JSON
    class Generator
      class MinimumAttribute
        def generate(properties, generator)
          type          = properties["type"]
          minimum_value = properties["minimum"]

          case type
          when "integer"
            [minimum_value - 1]
          else
            warn "not impremented type: #{type}"
          end
        end
      end
    end
  end
end
