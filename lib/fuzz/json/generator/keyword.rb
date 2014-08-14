Dir[File.join(File.dirname(__FILE__), "keyword/*.rb")].each {|file| require file }

module Fuzz
  module JSON
    module Generator
      class Keyword 
        class << self
          def keyword_to_class_map
            {
              "minimum" => Fuzz::JSON::Generator::Keyword::Minimum,
              "maximum" => Fuzz::JSON::Generator::Keyword::Maximum,
            }
          end
        end
      end
    end
  end
end
