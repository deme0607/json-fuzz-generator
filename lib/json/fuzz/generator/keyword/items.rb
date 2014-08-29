module JSON
  module Fuzz
    module Generator
      class Keyword
        class Items
          class << self
            def invalid_params(attributes)
              attributes = Marshal.load(Marshal.dump(attributes))
              items  = attributes.delete("items")
              raise "No items keyword given: #{attributes}" unless items

              generated_params = []

              if items.instance_of?(Hash)
                invalid_param = []
                JSON::Fuzz::Generator.generate(items).each do |invalid_item|
                  invalid_param << invalid_item
                end
                generated_params << invalid_param
              else
                invalid_param = []
                items.each do |item|
                  JSON::Fuzz::Generator.generate(item).each do |invalid_item|
                    invalid_param << invalid_item
                  end
                end
                generated_params << invalid_param
              end

              if attributes.key?("additionalItems")
                additional_items = attributes.delete("additionalItems")
                template = valid_param(attributes.merge("items" => items))

                if additional_items
                  template << JSON::Fuzz::Generator.generate(additional_items).sample
                  generated_params << template
                else
                  template << template.sample
                  generated_params << template
                end
              end

              generated_params
            end

            def valid_param(attributes)
              attributes = Marshal.load(Marshal.dump(attributes))
              items  = attributes.delete("items")
              raise "No items keyword given: #{attributes}" unless items

              generated_param = []

              if items.instance_of?(Hash)
                generated_param = JSON::Fuzz::Generator.default_param(items)
              else
                items.each do |item|
                  generated_param << JSON::Fuzz::Generator.default_param(item)
                end
              end

              generated_param
            end
          end
        end
      end
    end
  end
end
