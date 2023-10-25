module JSONSchemer
  module Fuzz
    class Keyword
      class AllOf
        class << self
          # @return Array
          def invalid_params(attributes)
            all_of = attributes["allOf"]
            raise "No allOf keyword given: #{attributes}" unless all_of

            generated_params = []

            all_of.each do |schema|
              JSONSchemer::Fuzz.generate(schema).each do |invalid_param|
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

          # @return Hash
          def valid_param(attributes)
            attributes = Marshal.load(Marshal.dump(attributes))
            all_of = attributes.delete("allOf")
            raise "No allOf keyword given: #{attributes}" unless all_of

            generated_param = {}

            all_of.each do |schema|
              generated_param.merge!(JSONSchemer::Fuzz.default_param(schema))
            end

            generated_param
          end
        end
      end
    end
  end
end
