module Fuzz
  module JSON
    module Generator
      class Keyword
        class MultipleOf
          class << self
            def invalid_params(attributes)
              multiple_of = attributes["multipleOf"]
              raise "No multipleOf keyword given: #{attributes}" unless multiple_of

              [multiple_of * 0.9]
            end

            def valid_param(attributes)
              multiple_of = attributes["multipleOf"]
              raise "No multipleOf keyword given: #{attributes}" unless multiple_of

              multiple_of * Random.rand(1..10)
            end
          end
        end
      end
    end
  end
end
