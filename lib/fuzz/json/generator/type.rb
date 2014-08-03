module Fuzz
  module JSON
    class Generator
      class TypeAttribute
        def generate(properties, generator)
          attribute = properties["type"]
          case attribute
          when "object"
            nil
          when "integer"
            ["1", "a"]
          when "string"
            [1]
          else
            warn "not impremented attribute: #{attribute}"
          end
        end
      end
    end
  end
end
