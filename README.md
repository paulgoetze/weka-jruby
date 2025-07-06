# Weka

[![Gem Version](https://badge.fury.io/rb/weka.svg)](http://badge.fury.io/rb/weka)
[![Build Status](https://github.com/paulgoetze/weka-jruby/workflows/Tests/badge.svg)](https://github.com/paulgoetze/weka-jruby/workflows/Tests/badge.svg)

Machine Learning & Data Mining with JRuby based on the
[Weka](https://ml.cms.waikato.ac.nz/weka/) Java library.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'weka'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install weka

## Usage

Use Weka's Machine Learning and Data Mining algorithms by requiring the gem:

```ruby
require 'weka'
```

The weka gem tries to carry over the namespaces defined in Weka and enhances
some interfaces in order to allow a more Ruby-ish programming style when using
the Weka library.

The idea behind keeping the namespaces is, that you can also use the
[Weka documentation](http://weka.sourceforge.net/doc.dev/) for looking up
functionality and classes.

Please refer to [the gem’s Wiki](https://github.com/paulgoetze/weka-jruby/wiki)
for detailed information about how to use weka with JRuby and some examplary
code snippets.

## Development

1. Check out the repo with `git clone git@github.com:paulgoetze/weka-jruby.git`.
2. Set a local environment variable `export JARS_VENDOR=false`. This will
   prevent compiling the jars into your repo’s /lib directory and will load them
   from your local maven repository instead. See the
   [jar-dependencies README](https://github.com/mkristian/jar-dependencies#for-development-you-do-not-need-to-vendor-the-jars-at-all)
   for more information.
3. Run `bin/setup` or `bundle install` to install the dependencies.

Then, run `rake spec` to run the tests. You can also run `bin/console` or
`rake irb` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/paulgoetze/weka-jruby. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the
[Contributor Covenant Code of Conduct](https://github.com/paulgoetze/weka-jruby/blob/main/CODE_OF_CONDUCT.md).

For development we use the
[git branching model](http://nvie.com/posts/a-successful-git-branching-model/)
described by [nvie](https://github.com/nvie).

Here’s how to contribute:

1. Fork it (https://github.com/paulgoetze/weka-jruby/fork)
2. Create your feature branch (`git checkout -b feature/my-new-feature develop`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create a new Pull Request

Please try to add RSpec tests along with your new feature. This will ensure that
your code does not break existing functionality and that your feature is working
as expected.

We use [Rubocop](https://github.com/bbatsov/rubocop) for code style
recommendations. Please make sure your contributions comply with the project’s
Rubocop config.

## Acknowledgement

The original ideas for wrapping Weka in JRuby come from
[@arrigonialberto86](https://github.com/arrigonialberto86) and his
[ruby-band](https://github.com/arrigonialberto86/ruby-band) gem. Great thanks!

## License

The gem is available as open source under the terms of the
[MIT License](https://github.com/paulgoetze/weka-jruby/blob/main/MIT-LICENSE.txt).
