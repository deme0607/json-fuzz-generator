module JSON
  module Fuzz
    module Generator
      class Keyword
        class MaxLength
          class << self
            def invalid_params(attributes)
              max_length = attributes["maxLength"]
              raise "No maxLength keyword given: #{attributes}" unless max_length

              generated_params = []

              generated_params << /\w{1}/.gen * (max_length + 1)

              return generated_params
            end

            def valid_param(attributes)
              max_length = attributes["maxLength"]
              raise "No maxLength keyword given: #{attributes}" unless max_length

              /\w{1}/.gen * max_length
            end
          end
        end
      end
    end
  end
end
