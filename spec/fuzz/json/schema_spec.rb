require "spec_helper"

describe Fuzz::JSON do
  context "basic features" do
    it "works" do
      schema_file = File.join(SPEC_SCHEMA_ROOT, "basic_schema.json")
      fuzz_params_list = Fuzz::JSON::Generator.generate(schema_file)

      fuzz_params_list.each do |params|
        expect(params).to include("id", "name", "age")
        result = JSON::Validator.validate(schema_file, params)
        expect(result).to eq(false)
      end
    end
  end

  context "primitive types" do
    it "works" do
      schema_file      = File.join(SPEC_SCHEMA_ROOT, "primitive_types.json")
      generator        = Fuzz::JSON::Generator.new
      default_param    = generator.default_param(schema_file)
      fuzz_params_list = generator.generate(schema_file)

      fuzz_params_list.each do |params|
        expect(params).to include(*default_param.keys)
        warn params
        result = JSON::Validator.validate(schema_file, params)
        expect(result).to eq(false)
      end
    end
  end
end
