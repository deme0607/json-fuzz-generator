module JSONSchemer
  module Fuzz
    class Keyword
      class Enum
        class << self
          # @return Array
          def invalid_params(attributes)
            attributes = Marshal.load(Marshal.dump(attributes))
            enum = attributes.delete("enum")
            raise "No enum keyword given: #{attributes}" unless enum

            generated_params = []
            JSONSchemer::Fuzz::GENERATOR_MAP.each do |type, klass|
              klass.invalid_params(attributes).each do |invalid_param|
                generated_params << invalid_param unless enum.include?(invalid_param)
              end
            end

            generated_params.empty? ? [nil] : generated_params
          end

          def valid_param(attributes)
            enum = attributes["enum"]
            raise "No enum keyword given: #{attributes}" unless enum

            enum.sample
          end
        end
      end
    end
  end
end
