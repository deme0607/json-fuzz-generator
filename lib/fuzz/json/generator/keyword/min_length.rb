module Fuzz
  module JSON
    module Generator
      class Keyword
        class MinLength
          class << self
            def invalid_params(attributes)
              min_length = attributes["minLength"]
              raise "No minLength keyword given: #{attributes}" unless min_length

              generated_params = []

              generated_params << /\w{1}/.gen * (min_length - 1)

              return generated_params
            end

            def valid_param(attributes)
              min_length = attributes["minLength"]
              raise "No minLength keyword given: #{attributes}" unless min_length

              /\w{1}/.gen * min_length
            end
          end
        end
      end
    end
  end
end
