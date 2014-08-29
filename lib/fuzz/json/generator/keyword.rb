Dir[File.join(File.dirname(__FILE__), "keyword/*.rb")].each {|file| require file }

module Fuzz
  module JSON
    module Generator
      class Keyword 
      end
    end
  end
end
