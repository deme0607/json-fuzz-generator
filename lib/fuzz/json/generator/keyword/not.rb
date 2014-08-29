module Fuzz
  module JSON
    module Generator
      class Keyword
        class Not
          class << self
            def invalid_params(attributes)
              not_attribute = attributes["not"]
              raise "No not keyword given: #{attributes}" unless not_attribute

              [Fuzz::JSON::Generator.default_param(not_attribute)]
            end

            def valid_param(attributes)
              attributes = Marshal.load(Marshal.dump(attributes))
              not_attribute = attributes.delete("not")
              raise "No not keyword given: #{attributes}" unless not_attribute
              
              generated_params = Fuzz::JSON::Generator.generate(not_attribute)

              generated_params.sample
            end
          end
        end
      end
    end
  end
end
