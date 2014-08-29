module JSON
  module Fuzz
    module Generator
      class Keyword
        class Dependencies
          class << self
            def invalid_params(attributes)
              attributes = Marshal.load(Marshal.dump(attributes))
              dependencies = attributes.delete("dependencies")
              raise "No dependencies keyword given: #{attributes}" unless dependencies

              generated_params = []
              template = JSON::Fuzz::Generator.default_param(attributes)
              
              dependencies.each do |key, dependency|
                dependency.each do |required_key|
                  invalid_param = Marshal.load(Marshal.dump(template))
                  invalid_param.delete(required_key)
                  generated_params << invalid_param
                end
              end

              generated_params
            end

            def valid_param(attributes)
              attributes = Marshal.load(Marshal.dump(attributes))
              dependencies = attributes.delete("dependencies")
              raise "No dependencies keyword given: #{attributes}" unless dependencies
              
              generated_params = []

              dependencies.each do |key, dependency|
                template = JSON::Fuzz::Generator.default_param(attributes)
                template[key] = "hoge" if template.keys.size == 0
                dependency.each do |required_key|
                  template.merge!(required_key => template[template.keys.sample]) unless template.key?(required_key)
                  generated_params << template
                end
              end

              generated_params.sample
            end
          end
        end
      end
    end
  end
end
