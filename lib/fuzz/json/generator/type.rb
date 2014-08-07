module Fuzz
  module JSON
    class Generator
      class TypeAttribute
        def generate(properties, generator)
          attribute = properties["type"]
          case attribute
          when "object"
            [nil, []]
          when "integer"
            ["1", "a"]
          when "string"
            [1]
          when "array"
            {}
          when "boolean"
            ["true", "false", "1", "0"]
          when "number"
            ["0.1", "10", "hoge"]
          when "null"
            ["nil", "0", "null", false, ""]
          else
            warn "not impremented attribute: #{attribute}"
          end
        end
      end
    end
  end
end
