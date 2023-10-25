module JSON
  module Fuzz
    module Generator
      class Keyword
        class OneOf 
          class << self
            def invalid_params(attributes)
              one_of = attributes["oneOf"]
              raise "No oneOf keyword given: #{attributes}" unless one_of
              raise "oneOf keyword given, but had no schemas: #{attributes["oneOf"]}" unless one_of.any?

              generated_params = []

              # Either all params need to be invalid, or all need to be valid.
              # For simplicity, we'll start with all invalid,
              #   but this could be extended to sometimes return all valid.
              one_of.each do |schema|
                temp_params = JSON::Fuzz::Generator.generate(schema).reject do |param|
                  ::JSONSchemer.schema(attributes).validate(param)
                end
                generated_params.concat(temp_params)
              end

              raise "failed to generate invalid_params for schema: #{attributes}" if generated_params.empty?
              [generated_params.uniq.sample]
            end

            def valid_param(attributes)
              one_of = attributes["oneOf"]
              raise "No oneOf keyword given: #{attributes}" unless one_of
              raise "oneOf keyword given, but had no schemas: #{attributes["oneOf"]}" unless one_of.any?

              generated_params = []

              # Only one of the oneOf can be valid, the others must not be, as it is an XOR
              # If one of the oneOf's is required,
              #   then then match for that schema cannot also match the other schemas.
              required_schema_index = one_of.index {|oof| oof["required"] }
              required_schema = one_of.delete_at(required_schema_index)
              if required_schema
                valid_required_param = JSON::Fuzz::Generator.default_param(required_schema).detect do |param|
                  ::JSONSchemer.schema(attributes).validate(param)
                end
                if valid_required_param
                  generated_params << valid_required_param
                else
                  one_of.each do |schema|
                    temp_param = JSON::Fuzz::Generator.generate(schema).detect do |param|
                      ::JSONSchemer.schema(attributes).validate(param)
                    end
                    if temp_param
                      generated_params << temp_param
                    else
                      # Allow to drop through to attempt to find another part of the oneOf to satisfy
                    end
                  end
                end
              end

              return generated_params.uniq.sample if generated_params.any?

              one_of.each do |schema|
                generated_params.concat(JSON::Fuzz::Generator.generate(schema).select do |param|
                  ::JSONSchemer.schema(attributes).validate(param)
                end)
              end

              raise "failed to generate invalid_params for schema: #{attributes}" if generated_params.empty?
              generated_params.uniq.sample
            end
          end
        end
      end
    end
  end
end
