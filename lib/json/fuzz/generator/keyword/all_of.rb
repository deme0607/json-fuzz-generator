module JSON
  module Fuzz
    module Generator
      class Keyword
        class AllOf 
          class << self
            def invalid_params(attributes)
              all_of = attributes["allOf"]
              raise "No allOf keyword given: #{attributes}" unless all_of

              generated_params = []

              all_of.each do |schema|
                JSON::Fuzz::Generator.generate(schema).each do |invalid_param|
                  if invalid_param.empty?
                    generated_params << invalid_param
                  else
                    template = valid_param(attributes)
                    template.merge!(invalid_param)
                    generated_params << template
                  end
                end
              end

              generated_params
            end

            def valid_param(attributes)
              attributes = Marshal.load(Marshal.dump(attributes))
              all_of = attributes.delete("allOf")
              raise "No allOf keyword given: #{attributes}" unless all_of
              
              generated_param = {}

              all_of.each do |schema|
                generated_param.merge!(JSON::Fuzz::Generator.default_param(schema))
              end

              generated_param
            end
          end
        end
      end
    end
  end
end
