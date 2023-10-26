module JSONSchemer
  module Fuzz
    class Keyword
      class Format
        class << self
          # @return Array
          def invalid_params(attributes)
            format = attributes["format"]
            raise "No format keyword given: #{attributes}" unless format

            if invalid_params = format_to_invalid_params(format)
              invalid_params
            else
              raise "invalid format type: #{attributes}"
            end
          end

          def valid_param(attributes)
            format = attributes["format"]
            raise "No format keyword given: #{attributes}" unless format

            if valid_params = format_to_valid_params(format)
              valid_params.sample
            else
              raise "invalid format type: #{attributes}"
            end
          end

          private

          def format_to_invalid_params(format)
            {
              "ipv4" => [
                "1",
                "1.1",
                "1.1.1",
                "1.1.1.1.1.1.1.1.1.1.1.1.1",
                "1.1.1.300",
                "1.1.1.1b",
                "b1.1.1.1",
                "donut",
              ],
              "ipv6" => [
                "1111:2222:8888:99999:aaaa:cccc:eeee:ffff",
                "1111:2222:8888:9999:aaaa:cccc:eeee:gggg",
                "1111:2222::9999::cccc:eeee:ffff",
                "1111:2222:8888:9999:aaaa:cccc:eeee:ffff:bbbb",
              ],
              # https://ijmacd.github.io/rfc3339-iso8601/
              "time" => [
                "12:00",
                "12:00:60",
                "12:60:00",
                "24:00:00",
                "0:00:00",
                "-12:00:00",
                "12:00:00b",
                "12:00:00",
              ],
              # https://ijmacd.github.io/rfc3339-iso8601/
              "date" => [
                "2010-01-32",
                "n2010-01-01",
                "2010-1-01",
                "2010-01-1",
                "2010-01-01n",
              ],
              # https://ijmacd.github.io/rfc3339-iso8601/
              "date-time" => [
                "2010-01-32T12:00:00Z",
                "2010-13-01T12:00:00Z",
                "2010-01-01T24:00:00Z",
                "2010-01-01T12:60:00Z",
                "2010-01-01T12:00:60Z",
                "2010-01-0112:00:00Z",
                "2010-01-01T12:00:00+0000",
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
              "ipv4" => ["1.1.1.1"],
              "ipv6" => [
                "1111:2222:8888:9999:aaaa:cccc:eeee:ffff",
                "1111:0:8888:0:0:0:eeee:ffff",
                "1111:2222:8888::eeee:ffff",
              ],
              # https://ijmacd.github.io/rfc3339-iso8601/
              "time" => ["12:00:00Z"],
              # https://ijmacd.github.io/rfc3339-iso8601/
              "date" => ["1992-06-27"],
              # https://ijmacd.github.io/rfc3339-iso8601/
              "date-time" => [
                "2010-01-01T12:00:00Z",
                "2010-01-01T12:00:00.1Z",
                # TODO: Uncomment once fixed in json_schemer: https://github.com/davishmcclurg/json_schemer/issues/151
                #       Valid ISO-8601, but not valid RFC-3339
                # "2010-01-01T12:00:00,1Z",
                "2010-01-01T12:00:00z", # RFC-3339 is case-insensitive!
                "2010-01-01T12:00:00+00:00",
              ],
              "uri" => ["http://example.com"],
              "email" => ["hoge@example.com"],
            }[format]
          end
        end
      end
    end
  end
end
