# JSONSchemer::Fuzz

A JSON FUZZ Generator in Ruby from JSON Schema files.

## Installation

Add this line to your application's Gemfile:

    gem 'json_schemer-fuzz'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json_schemer-fuzz

## Usage

### input JSON Schema

```json:input_schema.json
{
  "title": "Basic Schema",
  "type": "object",
  "properties": {
    "id" : {
      "type": "integer",
      "minimum": 0
    },
    "name": {
      "type": "string"
    },
    "birthday": {
      "type": "string",
      "format": "date"
    }
  }
}
```
### generate valid param

```ruby
require "json-fuzz-generator"
 
JSONSchemer::Fuzz.default_param(schema_file)
# => {"id"=>0, "name"=>"hoge", "birthday"=>"1992-06-27"}
```
### generate invalid params

```ruby
require "json-fuzz-generator"
 
JSONSchemer::Fuzz.generate(schema_file)
# => 
#[
#  ["sample", "array"],
#  true,
#  73,
#  nil,
#  0.34259093948835795,
#  "hoge",
#  {"id"=>"a", "name"=>"hoge", "birthday"=>"1992-06-27"},
#  {"id"=>"1", "name"=>"hoge", "birthday"=>"1992-06-27"},
#  {"id"=>0.1, "name"=>"hoge", "birthday"=>"1992-06-27"},
#  {"id"=>["sample", "array"], "name"=>"hoge", "birthday"=>"1992-06-27"},
#  {"id"=>false, "name"=>"hoge", "birthday"=>"1992-06-27"},
#  {"id"=>nil, "name"=>"hoge", "birthday"=>"1992-06-27"},
#  {"id"=>0.0, "name"=>"hoge", "birthday"=>"1992-06-27"},
#  {"id"=>{}, "name"=>"hoge", "birthday"=>"1992-06-27"},
#  {"id"=>"hoge", "name"=>"hoge", "birthday"=>"1992-06-27"},
#  {"id"=>-1, "name"=>"hoge", "birthday"=>"1992-06-27"},
#  {"id"=>0, "name"=>["sample", "array"], "birthday"=>"1992-06-27"},
#  {"id"=>0, "name"=>true, "birthday"=>"1992-06-27"},
#  {"id"=>0, "name"=>97, "birthday"=>"1992-06-27"},
#  {"id"=>0, "name"=>nil, "birthday"=>"1992-06-27"},
#  {"id"=>0, "name"=>0.7547537108664406, "birthday"=>"1992-06-27"},
#  {"id"=>0, "name"=>{}, "birthday"=>"1992-06-27"},
#  {"id"=>0, "name"=>"hoge", "birthday"=>["sample", "array"]},
#  {"id"=>0, "name"=>"hoge", "birthday"=>false},
#  {"id"=>0, "name"=>"hoge", "birthday"=>11},
#  {"id"=>0, "name"=>"hoge", "birthday"=>nil},
#  {"id"=>0, "name"=>"hoge", "birthday"=>0.5380909041403419},
#  {"id"=>0, "name"=>"hoge", "birthday"=>{}},
#  {"id"=>0, "name"=>"hoge", "birthday"=>"2010-01-32"},
#  {"id"=>0, "name"=>"hoge", "birthday"=>"n2010-01-01"},
#  {"id"=>0, "name"=>"hoge", "birthday"=>"2010-1-01"},
#  {"id"=>0, "name"=>"hoge", "birthday"=>"2010-01-1"},
#  {"id"=>0, "name"=>"hoge", "birthday"=>"2010-01-01n"},
#]
```

## Development

Run tests!

```shell
bundle install
bundle exec rspec spec
```

## Contributing

1. Fork it ( https://github.com/deme0607/json-fuzz-generator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
