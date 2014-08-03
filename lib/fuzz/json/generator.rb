module Fuzz
  module JSON
    class Generator
      class << self
        def generate(json_schema)
          [
            {"id" => "a"},
            {"id" => "1"},
          ]
        end
      end
    end
  end
end
