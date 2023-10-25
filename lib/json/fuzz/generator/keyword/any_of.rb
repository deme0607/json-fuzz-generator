module JSON
  module Fuzz
    module Generator
      class Keyword
        class AnyOf 
          class << self
            def invalid_params(attributes)
              any_of = attributes["anyOf"]
              raise "No anyOf keyword given: #{attributes}" unless any_of

              generated_params = []

              any_of.each do |schema|
                temp_params = JSON::Fuzz::Generator.generate(schema).reject do |param|
                  ::JSONSchemer.schema(attributes).validate(param)
                end
                temp_params.each {|e| generated_params << e}
              end

              raise "failed to generate invalid_params for schema: #{attributes}" if generated_params.empty?
              generated_params.uniq
            end

            def valid_param(attributes)
              attributes = Marshal.load(Marshal.dump(attributes))
              any_of = attributes.delete("anyOf")
              raise "No anyOf keyword given: #{attributes}" unless any_of
              
              generated_params = []

              any_of.each do |valid_schema|
                generated_param = JSON::Fuzz::Generator.default_param(valid_schema)
                generated_params << generated_param
              end

              generated_params.sample
            end
          end
        end
      end
    end
  end
end
