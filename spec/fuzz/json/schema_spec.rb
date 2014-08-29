require "spec_helper"

describe Fuzz::JSON do
  #context "basic features" do
  #  it "works" do
  #    schema_file = File.join(SPEC_SCHEMA_ROOT, "basic_schema.json")
  #    fuzz_params_list = Fuzz::JSON::Generator.generate(schema_file)

  #    fuzz_params_list.each do |params|
  #      result = JSON::Validator.validate(schema_file, params)
  #      expect(result).to eq(false)
  #    end
  #  end
  #end

  #context "primitive types" do
  #  it "works" do
  #    schema_file      = File.join(SPEC_SCHEMA_ROOT, "primitive_types.json")
  #    default_param    = Fuzz::JSON::Generator.default_param(schema_file)
  #    fuzz_params_list = Fuzz::JSON::Generator.generate(schema_file)

  #    fuzz_params_list.each do |params|
  #      result = JSON::Validator.validate(schema_file, params)
  #      expect(result).to eq(false)
  #    end
  #  end
  #end

  shared_examples_for Fuzz::JSON::Generator do
    context "#default_param" do
      it "can generate valid parameter" do
        valid_parameter = Fuzz::JSON::Generator.default_param(schema)
        expect(valid_parameter).to be_matching_schema(schema)
        #expect(JSON::Validator.validate(schema, valid_parameter)).to eq(true)
      end
    end

    context "#generate" do
      it "can generate invalid parameter" do
        invalid_parameters = Fuzz::JSON::Generator.generate(schema)
        invalid_parameters.each do |invalid_param|
          expect(invalid_param).to be_not_matching_schema(schema)
          #expect(JSON::Validator.validate(schema, invalid_param)).to eq(false)
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

  xcontext "strict option" do
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

    xcontext "with patternProperties" do
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

  xcontext "pattern" do
    it_behaves_like Fuzz::JSON::Generator do
      let(:schema) {{
        "$schema"    => "http://json-schema.org/draft-04/schema#",
        "properties" => {
          "a" => {"pattern" => "\\d+ takoyaki"},
        },
      }}
    end
  end

  context "minLength" do
    it_behaves_like Fuzz::JSON::Generator do
      let(:schema) {{
        "$schema"    => "http://json-schema.org/draft-04/schema#",
        "properties" => {
          "a" => {"minLength" => 1},
        },
      }}
    end
  end

  context "maxLength" do
    it_behaves_like Fuzz::JSON::Generator do
      let(:schema) {{
        "$schema"    => "http://json-schema.org/draft-04/schema#",
        "properties" => {
          "a" => {"maxLength" => 1},
        },
      }}
    end
  end

  context "enum" do
    it_behaves_like Fuzz::JSON::Generator do
      let(:schema) {{
        "$schema"    => "http://json-schema.org/draft-04/schema#",
        "properties" => {
          "a" => {"enum" => ["hoge", 22, [0, 3], {"foo" => "bar"}]},
        },
      }}
    end
  end

  context "multipleOf" do
    it_behaves_like Fuzz::JSON::Generator do
      let(:schema) {{
        "$schema"    => "http://json-schema.org/draft-04/schema#",
        "properties" => {
          "a" => {"multipleOf" => 1.3},
        },
      }}
    end
  end

  xcontext "patternProperties" do
    it_behaves_like Fuzz::JSON::Generator do
      let(:schema) {{
        "$schema"           => "http://json-schema.org/draft-04/schema#",
        "patternProperties" => {
          "\\d+ takoyaki" => {"type" => "integer"},
        },
      }}
    end
  end

  context "additionalProperties" do
    context "given no properties" do
      it_behaves_like Fuzz::JSON::Generator do
        let(:schema) {{
          "$schema"    => "http://json-schema.org/draft-04/schema#",
          "properties" => {
            "a" => {"type" => "integer"},
          },
          "additionalProperties" => false,
        }}
      end
    end

    context "given property of type" do
      it_behaves_like Fuzz::JSON::Generator do
        let(:schema) {{
          "$schema"    => "http://json-schema.org/draft-04/schema#",
          "properties" => {
            "a" => {"type" => "integer"},
          },
          "additionalProperties" => {"type" => "string"},
        }}
      end
    end

    xcontext "with patternProperties" do
      it_behaves_like Fuzz::JSON::Generator do
        let(:schema) {{
          "$schema"           => "http://json-schema.org/draft-04/schema#",
          "patternProperties" => {
            "\\d+ takoyaki" => {"type" => "integer"},
          },
          "additionalProperties" => false,
        }}
      end
    end
  end

  context "items" do
    context "given single property" do
      it_behaves_like Fuzz::JSON::Generator do
        let(:schema) {{
          "$schema" => "http://json-schema.org/draft-04/schema#",
          "items"   => {"type" => "integer"},
        }}
      end
    end

    context "given multiple properties" do
      it_behaves_like Fuzz::JSON::Generator do
        let(:schema) {{
          "$schema" => "http://json-schema.org/draft-04/schema#",
          "items"   => [
            {"type" => "integer"},
            {"type" => "string"},
          ],
        }}
      end
    end

    context "with additionalItems" do
      context "given false" do
        it_behaves_like Fuzz::JSON::Generator do
          let(:schema) {{
            "$schema" => "http://json-schema.org/draft-04/schema#",
            "items"   => [
              {"type" => "integer"},
              {"type" => "string"},
            ],
            "additionalItems" => false,
          }}
        end
      end

      context "given property" do
        it_behaves_like Fuzz::JSON::Generator do
          let(:schema) {{
            "$schema" => "http://json-schema.org/draft-04/schema#",
            "items"   => [
              {"type" => "integer"},
              {"type" => "string"},
            ],
            "additionalItems" => {"type" => "integer"},
          }}
        end
      end
    end
  end

  xcontext "self reference" do
    it_behaves_like Fuzz::JSON::Generator do
      let(:schema) {{
        "$schema"    => "http://json-schema.org/draft-04/schema#",
        "type"       => "object",
        "properties" => {
          "a" => {"type" => "integer"},
          "b" => {"$ref" => "#"},
        },
      }}
    end
  end

  %w[ip-address ipv6 time date date-time uri].each do |format|
    context "format #{format}" do
      it_behaves_like Fuzz::JSON::Generator do
        let(:schema) {{
          "$schema"    => "http://json-schema.org/draft-04/schema#",
          "type"       => "object",
          "properties" => {
            "a" => {
              "type"   => "string",
              "format" => format,
            },
          },
        }}
      end
    end
  end

  context "format with union types" do
    it_behaves_like Fuzz::JSON::Generator do
      let(:schema) {{
        "$schema"    => "http://json-schema.org/draft-04/schema#",
        "type"       => "object",
        "properties" => {
          "a" => {
            "type"   => ["string", "null"],
            "format" => "ip-address",
          },
        },
      }}
    end
  end

  context "dependencies" do
    context "given single property" do
      it_behaves_like Fuzz::JSON::Generator do
        let(:schema) {{
          "$schema"    => "http://json-schema.org/draft-04/schema#",
          "type"       => "object",
          "properties" => {
            "a" => {"type" => "integer"},
            "b" => {"type" => "integer"},
          },
          "dependencies" => {"a" => ["b"]},
        }}
      end
    end

    context "given multiple properties" do
      it_behaves_like Fuzz::JSON::Generator do
        let(:schema) {{
          "$schema"    => "http://json-schema.org/draft-04/schema#",
          "type"       => "object",
          "properties" => {
            "a" => {"type" => "integer"},
            "b" => {"type" => "integer"},
          },
          "dependencies" => {"a" => ["b", "c"]},
        }}
      end
    end
  end

  context "default" do
    it_behaves_like Fuzz::JSON::Generator do
      let(:schema) {{
        "$schema"    => "http://json-schema.org/draft-04/schema#",
        "type"       => "object",
        "properties" => {
          "a" => {"type" => "integer", "default" => 22},
          "b" => {"type" => "integer"},
        },
      }}
    end

    context "with readonly" do
      it_behaves_like Fuzz::JSON::Generator do
        let(:schema) {{
          "$schema"    => "http://json-schema.org/draft-04/schema#",
          "type"       => "object",
          "properties" => {
            "a" => {"type" => "integer", "default" => 22, "readonly" => true},
            "b" => {"type" => "integer"},
          },
        }}
      end
    end
  end

  %w[allOf anyOf oneOf].each do |keyword|
    context keyword do
      it_behaves_like Fuzz::JSON::Generator do
        let(:schema) {{
          "$schema" => "http://json-schema.org/draft-04/schema#",
          keyword   => [
            {
              "properties" => {"a" => {"type" => "string"}},
              "required"   => ["a"],
            },
            {
              "properties" => {"b" => {"type" => "integer"}},
            },
          ]
        }}
      end
    end
  end

  context "not" do
    it_behaves_like Fuzz::JSON::Generator do
      let(:schema) {{
        "$schema"    => "http://json-schema.org/draft-04/schema#",
        "properties" => {
          "a" => {"not" => {"type" => ["string", "boolean"]}},
        },
      }}
    end

    context "with sub schema" do
      it_behaves_like Fuzz::JSON::Generator do
        let(:schema) {{
          "$schema"    => "http://json-schema.org/draft-04/schema#",
          "properties" => {"a" => {"not" => {"anyOf" => [
            {"type" => ["string", "boolean"]},
            {"type" => "object", "properties" => {"b" => {"type" => "boolean"}}},
          ]}}},
        }}
      end
    end
  end

  xcontext "definitions" do
    it_behaves_like Fuzz::JSON::Generator do
      let(:schema) {{
        "$schema"     => "http://json-schema.org/draft-04/schema#",
        "type"        => "array",
        "items"       => {"$ref" => "#/definitions/positiveInteger"},
        "definitions" => {
          "positiveInteger" => {
            "type"             => "integer",
            "minimum"          => 0,
            "exclusiveMinimum" => true,
          },
        },
      }}
    end
  end
end
