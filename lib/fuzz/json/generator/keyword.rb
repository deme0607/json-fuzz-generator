Dir[File.join(File.dirname(__FILE__), "keyword/*.rb")].each {|file| require file }

module Fuzz
  module JSON
    module Generator
      class Keyword 
        class << self
          def keyword_to_class_map
            {
              "members"       => Fuzz::JSON::Generator::Keyword::Properties,
              "properties"    => Fuzz::JSON::Generator::Keyword::Properties,
              "required"      => Fuzz::JSON::Generator::Keyword::Required,
              "minimum"       => Fuzz::JSON::Generator::Keyword::Minimum,
              "maximum"       => Fuzz::JSON::Generator::Keyword::Maximum,
              "minItems"      => Fuzz::JSON::Generator::Keyword::MinItems,
              "maxItems"      => Fuzz::JSON::Generator::Keyword::MaxItems,
              "minProperties" => Fuzz::JSON::Generator::Keyword::MinProperties,
              "maxProperties" => Fuzz::JSON::Generator::Keyword::MaxProperties,
              "uniqueItems"   => Fuzz::JSON::Generator::Keyword::UniqueItems,
              "pattern"       => Fuzz::JSON::Generator::Keyword::Pattern,
              "minLength"     => Fuzz::JSON::Generator::Keyword::MinLength,
              "maxLength"     => Fuzz::JSON::Generator::Keyword::MaxLength,
              "enum"          => Fuzz::JSON::Generator::Keyword::Enum,
              "multipleOf"    => Fuzz::JSON::Generator::Keyword::MultipleOf,
            }
          end
        end
      end
    end
  end
end
