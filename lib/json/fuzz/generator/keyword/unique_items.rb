module JSON
  module Fuzz
    module Generator
      class Keyword
        class UniqueItems
          class << self
            def invalid_params(attributes)
              unique_items_flag = attributes["uniqueItems"]
              raise "No uniqueItems keyword given: #{attributes}" if unique_items_flag.nil?
              return unless unique_items_flag 

              generated_params = []
              template = valid_param(attributes)
              template << template.sample
              generated_params << template 
              
              generated_params
            end

            def valid_param(attributes)
              attributes = Marshal.load(Marshal.dump(attributes))
              unique_items_flag = attributes.delete("uniqueItems")
              raise "No uniqueItems keyword given: #{attributes}" if unique_items_flag.nil?
              return unless unique_items_flag 
              
              JSON::Fuzz::Generator.generators("array").valid_param(attributes).uniq
            end
          end
        end
      end
    end
  end
end
