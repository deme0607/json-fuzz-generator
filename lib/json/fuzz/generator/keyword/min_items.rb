module JSON
  module Fuzz
    module Generator
      class Keyword
        class MinItems
          class << self
            def invalid_params(attributes)
              attributes = Marshal.load(Marshal.dump(attributes))
              min_items  = attributes.delete("minItems")
              raise "No minItems keyword given: #{attributes}" unless min_items

              generated_params = []
              invalid_param    = []

              (min_items - 1).times do
                invalid_param << JSON::Fuzz::Generator.default_param(attributes)
              end

              generated_params << invalid_param

              generated_params
            end

            def valid_param(attributes)
              attributes = Marshal.load(Marshal.dump(attributes))
              min_items  = attributes.delete("minItems")
              raise "No minItems keyword given: #{attributes}" unless min_items

              generated_param = []
              
              min_items.times do
                item = JSON::Fuzz::Generator.default_param(attributes)
                item = "null" if item.nil?
                generated_param << "null"
              end

              generated_param
            end
          end
        end
      end
    end
  end
end
