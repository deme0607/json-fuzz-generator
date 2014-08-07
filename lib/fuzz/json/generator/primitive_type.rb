Dir[File.join(File.dirname(__FILE__), "primitive_type/*.rb")].each {|file| require file }

module Fuzz
  module JSON
    class Generator
      class PrimitiveType
      end
    end
  end
end

