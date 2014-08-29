module JSON
  module Fuzz
    module Generator
      class Keyword
        class Format
          class << self
            def invalid_params(attributes)
              format  = attributes["format"]
              raise "No format keyword given: #{attributes}" unless format

              if invalid_params = format_to_invalid_params(format)
                return invalid_params
              else
                raise "invalid format type: #{attributes}"
              end
            end

            def valid_param(attributes)
              format  = attributes["format"]
              raise "No format keyword given: #{attributes}" unless format

              if valid_params = format_to_valid_params(format)
                return valid_params.sample
              else
                raise "invalid format type: #{attributes}"
              end
            end

            private
            def format_to_invalid_params(format)
              {
                "ip-address" => [
                  "1.1.1", "1.1.1.300", 5, 
                  "1.1.1", "1.1.1.1b",  "b1.1.1.1"
                ],
                "ipv6" => [
                  "1111:2222:8888:99999:aaaa:cccc:eeee:ffff",
                  "1111:2222:8888:9999:aaaa:cccc:eeee:gggg",
                  "1111:2222::9999::cccc:eeee:ffff",
                  "1111:2222:8888:9999:aaaa:cccc:eeee:ffff:bbbb",
                ],
                "time" => [
                  "12:00",   "12:00:60",  "12:60:00", "24:00:00",
                  "0:00:00", "-12:00:00", "12:00:00b"
                ],
                "date" => [
                  "2010-01-32", "n2010-01-01", "2010-1-01", 
                  "2010-01-1",  "2010-01-01n"
                ],
                "date-time" => [
                  "2010-01-32T12:00:00Z", "2010-13-01T12:00:00Z",
                  "2010-01-01T24:00:00Z", "2010-01-01T12:60:00Z",
                  "2010-01-01T12:00:60Z", "2010-01-01T12:00:00z",
                  "2010-01-0112:00:00Z",
                ],
                "uri" => [
                  "::hoge",
                ],
                "email" => [
                  "@example.com",
                  "hoge",
                  "http://example.com",
                ],
              }[format]
            end
            
            def format_to_valid_params(format)
              {
                "ip-address" => ["1.1.1.1"],
                "ipv6" => [
                    "1111:2222:8888:9999:aaaa:cccc:eeee:ffff",
                    "1111:0:8888:0:0:0:eeee:ffff",
                    "1111:2222:8888::eeee:ffff",
                ],
                "time" => ["12:00:00"],
                "date" => ["1992-06-27"],
                "date-time" => [
                  "2010-01-01T12:00:00Z",
                  "2010-01-01T12:00:00.1Z",
                  "2010-01-01T12:00:00,1Z",
                  "2010-01-01T12:00:00+0000",
                  "2010-01-01T12:00:00+00:00",
                ],
                "uri" => ["http://gitbuh.com"],
                "email" => ["hoge@example.com"],
              }[format]
            end
          end
        end
      end
    end
  end
end
