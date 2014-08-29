module JSON
  module Fuzz
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

              string_num = multiple_of.to_s
              demicals   = string_num.split(".").length == 2 ? string_num.split(".")[-1].length : 0

              multiple_num = ("%.#{demicals}f" % (multiple_of * Random.rand(1..10)))
              multiple_of.instance_of?(Float) ? multiple_num.to_f : multiple_num.to_i
            end
          end
        end
      end
    end
  end
end
