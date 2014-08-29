module JSON
  module Fuzz
    module Generator
      class Keyword 
        Dir[File.join(File.dirname(__FILE__), "keyword/*.rb")].each {|file| require file }
      end
    end
  end
end
