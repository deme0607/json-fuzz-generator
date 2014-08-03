module Fuzz
  module JSON
    class Generator
      class << self
        def generate(json_schema)
          generator = Fuzz::JSON::Generator.new
          generator.generate(json_schema)
        end
      end

      attr_accessor :generators

      def initialize
        @generators = {}
        @generators["type"]       = Fuzz::JSON::Generator::TypeAttribute.new
        @generators["properties"] = Fuzz::JSON::Generator::PropertiesAttribute.new
        @generators["minimum"]    = Fuzz::JSON::Generator::MinimumAttribute.new
      end

      def generate(schema)
        json_schema = ::JSON::Validator.parse(open(schema).read)
        generated_params = []
        valid_param = default_param(schema)

        json_schema.each do |attr_name, attribute|
          if @generators.key?(attr_name)
            invalid_params = @generators[attr_name].generate(json_schema, self)
            if invalid_params
              invalid_params.each { |param| generated_params.push(valid_param.merge(param)) }
            end
          end
        end

        generated_params
      end

      def default_param(schema)
        {
          "id"   => 1,
          "name" => "deme0607",
          "age"  => 27,
        }
      end
    end
  end
end
