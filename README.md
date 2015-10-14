# Weka

[![Gem Version](https://badge.fury.io/rb/weka.svg)](http://badge.fury.io/rb/weka)
[![Travis Build](https://travis-ci.org/paulgoetze/weka-jruby.svg)](https://travis-ci.org/paulgoetze/weka-jruby)

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

Start using Weka's Machine Learning and Data Mining algorithms by requiring the gem:

```ruby
require 'weka'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/paulgoetze/weka-jruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant code of conduct](http://contributor-covenant.org/version/1/2/0).

For development we use the [git branching model](http://nvie.com/posts/a-successful-git-branching-model/) described by [nvie](https://github.com/nvie).

Here's how to contribute:

1. Fork it ( https://github.com/paulgoetze/weka-jruby/fork )
2. Create your feature branch (`git checkout -b feature/my-new-feature develop`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create a new Pull Request

Please try to add RSpec tests along with your new features. This will ensure that your code does not break existing functionality and that your feature is working as expected.

## License

The gem is available as open source under the terms of the [GNU General Public License](http://www.gnu.org/licenses/gpl-3.0.en.html).
