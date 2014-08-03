require 'spec_helper'

describe Fuzz::JSON do
  context "basic features" do
    it "integer works" do
      schema_file = File.join(SPEC_SCHEMA_ROOT, "base_schema.json")
      fuzz_params_list = Fuzz::JSON::Generator.generate(schema_file)

      fuzz_params_list.each do |params|
        expect(params).to include("id")
        result = JSON::Validator.validate(schema_file, params)
        expect(result).to eq(false)
      end
    end
  end
end
