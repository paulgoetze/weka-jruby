# Weka

[![Gem Version](https://badge.fury.io/rb/weka.svg)](http://badge.fury.io/rb/weka)
[![Travis Build](https://travis-ci.org/paulgoetze/weka-jruby.svg)](https://travis-ci.org/paulgoetze/weka-jruby)

Machine Learning & Data Mining with JRuby based on the [Weka](http://www.cs.waikato.ac.nz/~ml/weka/index.html) Java library.

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

### Instances

Instances objects hold the dataset that is used to train a classifier or that
should be classified based on training data.

Instances can be loaded from files and saved to files.
Supported formats are *ARFF*, *CSV*, and *JSON*.

#### Loading Instances from a file

Instances can be loaded from ARFF, CSV, and JSON files:

```ruby
instances = Weka::Core::Loader.load_arff('weather.arff')
instances = Weka::Core::Loader.load_csv('weather.csv')
instances = Weka::Core::Loader.load_json('weather.json')
```

#### Creating Instances and saving them as files

Attributes of an Instances object can be defined in a block using the `with_attributes` method:

```ruby
# create instances with relation name 'weather' and attributes
instances = Weka::Core::Instances.new('weather').with_attributes do
  nominal :outlook, ['sunny', 'overcast', 'rainy']
  numeric :temperature
  numeric :humidity
  nominal :windy, [true, false]
  date    :last_storm, 'yyyy-MM-dd'
  nominal :play, [:yes, :no]
end

# save as ARFF, CSV, or JSON file
instances.to_arff('weather.arff')
instances.to_csv('weather.csv')
instances.to_json('weather.json')
```

#### Adding additional attributes

You can add additional attributes to the Instances after its initialization.
All records that are already in the dataset will get an unknown value (`?`) for
the new attribute.

```ruby
instances.add_numeric_attribute(:pressure)
instances.add_nominal_attribute(:grandma_says, [:hm, :bad, :terrible])
instances.add_date_attribute(:last_rain, 'yyyy-MM-dd HH:mm')
```

#### Adding a data instance

You can add a data instance to the Instances by using the `add_instance` method:

```ruby
data = [:sunny, 70, 80, true, '2015-12-06', :yes, 1.1, :hm, '2015-12-24 20:00']
instances.add_instance(data)

# with custom weight:
instances.add_instance(data, weight: 2.0)
```

#### Alias methods

`Weka::Core::Instances` has following alias methods:

| method            | alias                   |
|-------------------|-------------------------|
| `numeric`         | `add_numeric_attribute` |
| `nominal`         | `add_nominal_attribute` |
| `date`            | `add_date_attribute`    |
| `string`          | `add_string_attribute`  |
| `with_attributes` | `add_attributes`        |

The shorter methods on the left side are meant to be used when defining
attributes in a block when using `#with_attributes` (or `#add_attributes`).

The longer, more descriptive methods are meant to be used for explicitly adding
attributes to an Instances object later on.

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
