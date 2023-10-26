# JSONSchemer::Fuzz

A JSON FUZZ Generator in Ruby from JSON Schema files.

This gem is a re-write & renaming of dead-since-2015 [`json-fuzz-generator`](https://github.com/deme0607/json-fuzz-generator),
It has been re-built on top of the modern [`json_schemer`](https://github.com/davishmcclurg/json_schemer)
instead of the unmaintained `json-schema`.

<div id="badges">

[![Test Coverage][🔑cc-covi]][🔑cc-cov]
[![Maintainability][🔑cc-mnti]][🔑cc-mnt]
[![Depfu][🔑depfui]][🔑depfu]

-----

[![Liberapay Patrons][⛳liberapay-img]][⛳liberapay]
[![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor]
<span class="badge-buymeacoffee">
   <a href="https://ko-fi.com/O5O86SNP4" target='_blank' title="Donate to my FLOSS or refugee efforts at ko-fi.com"><img src="https://img.shields.io/badge/buy%20me%20coffee-donate-yellow.svg" alt="Buy me coffee donation button" /></a>
</span>
<span class="badge-patreon">
   <a href="https://patreon.com/galtzo" title="Donate to my FLOSS or refugee efforts using Patreon"><img src="https://img.shields.io/badge/patreon-donate-yellow.svg" alt="Patreon donate button" /></a>
</span>

</div>

[⛳liberapay-img]: https://img.shields.io/liberapay/patrons/pboling.svg?logo=liberapay
[⛳liberapay]: https://liberapay.com/pboling/donate
[🖇sponsor-img]: https://img.shields.io/badge/Sponsor_Me!-pboling.svg?style=social&logo=github
[🖇sponsor]: https://github.com/sponsors/pboling

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

```#<--rubocop/md-->ruby
require "json-fuzz-generator"

JSONSchemer::Fuzz.default_param(schema_file)
# => {"id"=>0, "name"=>"hoge", "birthday"=>"1992-06-27"}
```
### generate invalid params

```#<--rubocop/md-->ruby
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

```#<--rubocop/md-->shell
bundle install
bundle exec rspec spec
```

## Contributing

See [CONTRIBUTING.md][🪇conduct]

[🪇conduct]: CONTRIBUTING.md

## 🪇 Code of Conduct

Everyone interacting in this project's codebases, issue trackers,
chat rooms and mailing lists is expected to follow the [code of conduct][🪇conduct].

[🪇conduct]: CODE_OF_CONDUCT.md

## 📌 Versioning

This Library adheres to [Semantic Versioning 2.0.0][📌semver].
Violations of this scheme should be reported as bugs.
Specifically, if a minor or patch version is released that breaks backward compatibility,
a new version should be immediately released that restores compatibility.
Breaking changes to the public API will only be introduced with new major versions.

To get a better understanding of how SemVer is intended to work over a project's lifetime,
read this article from the creator of SemVer:

- ["Major Version Numbers are Not Sacred"][📌major-versions-not-sacred]

As a result of this policy, you can (and should) specify a dependency on these libraries using
the [Pessimistic Version Constraint][📌pvc] with two digits of precision.

For example:

```#<--rubocop/md-->ruby
spec.add_dependency "json_schemer-fuzz", "~> 1.0"
```

[comment]: <> ( VERSIONING LINKS )

[📌pvc]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint
[📌semver]: http://semver.org/
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html

## 📄 License

The gem is available as open source under the terms of
the [MIT License][📄license] [![License: MIT][📄license-img]][📄license-ref].
See [LICENSE.txt][📄license] for the official [Copyright Notice][📄copyright-notice-explainer].

[comment]: <> ( LEGAL LINKS )

[📄copyright-notice-explainer]: https://opensource.stackexchange.com/questions/5778/why-do-licenses-such-as-the-mit-license-specify-a-single-year
[📄license]: LICENSE.txt
[📄license-ref]: https://opensource.org/licenses/MIT
[📄license-img]: https://img.shields.io/badge/License-MIT-green.svg

### © Copyright

* Copyright © 2014-2015 Naoki Shimizu
* Copyright © 2023 [Peter H. Boling][💁🏼‍️peterboling] of [Rails Bling][💁🏼‍️railsbling]

[comment]: <> ( COPYRIGHT LINKS )

[💁🏼‍️peterboling]: http://www.peterboling.com
[💁🏼‍️railsbling]: http://www.railsbling.com

[comment]: <> ( KEYED LINKS )

[🔑cc-mnt]: https://codeclimate.com/github/pboling/json_schemer-fuzz/maintainability
[🔑cc-mnti]: https://api.codeclimate.com/v1/badges/f39a86da0075bb88872a/maintainability
[🔑cc-cov]: https://codeclimate.com/github/pboling/json_schemer-fuzz/test_coverage
[🔑cc-covi]: https://api.codeclimate.com/v1/badges/f39a86da0075bb88872a/test_coverage
[🔑depfu]: https://depfu.com/github/pboling/json_schemer-fuzz?project_id=39376
[🔑depfui]: https://badges.depfu.com/badges/b44af6cec217d3436e0782ed6d9a3324/count.svg
