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
        result = JSON::Validator.validate(schema_file, params)
        expect(result).to eq(false)
      end
    end
  end

  shared_examples_for Fuzz::JSON::Generator do
    let(:generator) { Fuzz::JSON::Generator.new }

    context "#default_param" do
      it "can generate valid parameter" do
        valid_parameter = generator.default_param(schema)
        expect(JSON::Validator.validate(schema, valid_parameter)).to eq(true)
      end
    end

    context "#generate" do
      it "can generate invalid parameter" do
        invalid_parameters = generator.generate(schema)
        invalid_parameters.each do |invalid_param|
          expect(JSON::Validator.validate(schema, invalid_param)).to eq(false)
        end
      end
    end
  end

  context "types" do
    %w(integer number string object array null any).each do |type|
      context "when #{type}" do
        it_behaves_like Fuzz::JSON::Generator do
          let(:schema) {{
            "$schema" => "http://json-schema.org/draft-04/schema#",
            "type"    => type
          }}
        end
      end
    end

    context "when union type" do
      context "given integer and string" do
        it_behaves_like Fuzz::JSON::Generator do
          let(:schema) {{
            "$schema" => "http://json-schema.org/draft-04/schema#", 
            "type"    => ["integer", "string"],
          }}
        end
      end

      context "given string and null" do
        it_behaves_like Fuzz::JSON::Generator do
          let(:schema) {{
            "$schema" => "http://json-schema.org/draft-04/schema#", 
            "type"    => ["string", "null"],
          }}
        end
      end

      context "given integer and object" do
        it_behaves_like Fuzz::JSON::Generator do
          let(:schema) {{
            "$schema" => "http://json-schema.org/draft-04/schema#", 
            "type"    => ["integer", "object"],
          }}
        end
      end
    end
  end

  context "required" do
    it_behaves_like Fuzz::JSON::Generator do
      let(:schema) {{
        "$schema"    => "http://json-schema.org/draft-04/schema#", 
        "required"   => ["a"],
        "properties" => {
          "a" => {},
        },
      }}
    end
  end

  context "minimum" do
    context "without exclusiveMinimum" do
      it_behaves_like Fuzz::JSON::Generator do
        let(:schema) {{
          "$schema"    => "http://json-schema.org/draft-04/schema#", 
          "properties" => {
            "a" => {"minimum" => 100},
          },
        }}
      end
    end

    context "with exclusiveMinimum" do
      it_behaves_like Fuzz::JSON::Generator do
        let(:schema) {{
          "$schema"    => "http://json-schema.org/draft-04/schema#", 
          "properties" => {
            "a" => {
              "minimum"          => 100,
              "exclusiveMinimum" => true,
            },
          },
        }}
      end
    end
  end

  context "maximum" do
    context "without exclusiveMaximum" do
      it_behaves_like Fuzz::JSON::Generator do
        let(:schema) {{
          "$schema"    => "http://json-schema.org/draft-04/schema#", 
          "properties" => {
            "a" => {"maximum" => 3},
          },
        }}
      end
    end

    context "with exclusiveMaximum" do
      it_behaves_like Fuzz::JSON::Generator do
        let(:schema) {{
          "$schema"    => "http://json-schema.org/draft-04/schema#", 
          "properties" => {
            "a" => {
              "maximum"          => 3,
              "exclusiveMaximum" => true,
            },
          },
        }}
      end
    end
  end

  context "minItems" do
    it_behaves_like Fuzz::JSON::Generator do
      let(:schema) {{
        "$schema"    => "http://json-schema.org/draft-04/schema#", 
        "properties" => {
          "a" => {"minItems" => 5},
        },
      }}
    end
  end

  context "maxItems" do
    it_behaves_like Fuzz::JSON::Generator do
      let(:schema) {{
        "$schema"    => "http://json-schema.org/draft-04/schema#", 
        "properties" => {
          "a" => {"maxItems" => 3},
        },
      }}
    end
  end

  context "minProperties" do
    it_behaves_like Fuzz::JSON::Generator do
      let(:schema) {{
        "$schema"       => "http://json-schema.org/draft-04/schema#", 
        "minProperties" => 2,
        "properties"    => {},
      }}
    end
  end

  context "maxProperties" do
    it_behaves_like Fuzz::JSON::Generator do
      let(:schema) {{
        "$schema"       => "http://json-schema.org/draft-04/schema#", 
        "maxProperties" => 2,
        "properties"    => {},
      }}
    end
  end

  context "strict option" do
    shared_examples_for Fuzz::JSON::Generator do
      let(:generator) { Fuzz::JSON::Generator.new }

      context "#default_param" do
        it "can generate valid parameter" do
          valid_parameter = generator.default_param(schema, :strict => true)
          expect(JSON::Validator.validate(schema, valid_parameter, :strict => true)).to eq(true)
        end
      end

      context "#generate" do
        it "can generate invalid parameter" do
          invalid_parameters = generator.generate(schema, :strict => true)
          invalid_parameters.each do |invalid_param|
            expect(JSON::Validator.validate(schema, invalid_param, :strict => true)).to eq(false)
          end
        end
      end
    end

    context "without anly props" do
      it_behaves_like Fuzz::JSON::Generator do
        let(:schema) {{
          "$schema"    => "http://json-schema.org/draft-04/schema#",
          "properties" => {
            "a" => {"type" => "string"},
            "b" => {"type" => "string"},
          },
        }}
      end
    end

    context "with additionalProperties" do
      it_behaves_like Fuzz::JSON::Generator do
        let(:schema) {{
          "$schema"              => "http://json-schema.org/draft-04/schema#",
          "additionalProperties" => {"type" => "integer"},
          "properties"           => {
            "a" => {"type" => "string"},
            "b" => {"type" => "string"}
          },
        }}
      end
    end

    context "with patternProperties" do
      it_behaves_like Fuzz::JSON::Generator do
        let(:schema) {{
          "$schema"           => "http://json-schema.org/draft-04/schema#",
          "patternProperties" => {"\\d+ taco" => {"type" => "integer"}},
          "properties"        => {
            "a" => {"type" => "string"},
            "b" => {"type" => "string"},
          },
        }}
      end
    end
  end

  context "uniqueItems" do
    it_behaves_like Fuzz::JSON::Generator do
      let(:schema) {{
        "$schema"    => "http://json-schema.org/draft-04/schema#",
        "properties" => {
          "a" => {"uniqueItems" => true},
        },
      }}
    end
  end
end
