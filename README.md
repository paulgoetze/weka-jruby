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

The weka gem tries to carry over the namespaces defined in Weka and enhances some interfaces in order to allow a more Ruby-ish programming style when using the Weka library.

The idea behind keeping the namespaces is, that you can also use the [Weka documentation](http://weka.sourceforge.net/doc.dev/) for looking up functionality and classes.

Analog to the Weka doc you can find the following namespaces:

| Namespace                  | Description                                                      |
|----------------------------|------------------------------------------------------------------|
| `Weka::Core`               | defines base classes for loading, saving, creating, and editing a dataset |
| `Weka::Classifiers`        | defines classifier classes in different sub-modules (`Bayes`, `Functions`, `Lazy`, `Meta`, `Rules`, and `Trees`  ) |
| `Weka::Filters`            | defines filter classes for processing datasets in the `Supervised` or `Unsupervised`, and `Attribute` or `Instance` sub-modules                 |
| `Weka::Clusterers`         | defines clusterer classes                                        |
| `Weka::AttributeSelection` | defines classes for selecting attributes from a dataset          |

### Instances

Instances objects hold the dataset that is used to train a classifier or that
should be classified based on training data.

Instances can be loaded from files and saved to files.
Supported formats are *ARFF*, *CSV*, and *JSON*.

#### Loading Instances from a file

Instances can be loaded from ARFF, CSV, and JSON files:

```ruby
instances = Weka::Core::Instances.from_arff('weather.arff')
instances = Weka::Core::Instances.from_csv('weather.csv')
instances = Weka::Core::Instances.from_json('weather.json')
```

#### Creating Instances and saving them as files

Attributes of an Instances object can be defined in a block using the `with_attributes` method. The class attribute can be set by the `class_attribute: true` option on the fly with defining an attribute.

```ruby
# create instances with relation name 'weather' and attributes
instances = Weka::Core::Instances.new('weather').with_attributes do
  nominal :outlook, values: ['sunny', 'overcast', 'rainy']
  numeric :temperature
  numeric :humidity
  nominal :windy, values: [true, false]
  date    :last_storm, 'yyyy-MM-dd'
  nominal :play, values: [:yes, :no], class_attribute: true
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
instances.add_nominal_attribute(:grandma_says, values: [:hm, :bad, :terrible])
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

#### Setting a class attribute

You can set an earlier defined attribute as the class attribute of the dataset.
This allows classifiers to use the class for building a classification model while training.

```ruby
instances.add_nominal_attribute(:size, values: ['L', 'XL'], class_attribute: true
instances.class_attribute = :size
```

The added attribute can also be directly set as the class attribute:

```ruby
instances.add_nominal_attribute(:size, values: ['L', 'XL'], class_attribute: true)
```

Keep in mind that you can only assign existing attributes to be the class attribute.
The class attribute will not appear in the `instances.attributes` anymore and can be accessed with the `class_attribute` method.


#### Alias methods

`Weka::Core::Instances` has following alias methods:

| method                | alias                   |
|-----------------------|-------------------------|
| `numeric`             | `add_numeric_attribute` |
| `nominal`             | `add_nominal_attribute` |
| `date`                | `add_date_attribute`    |
| `string`              | `add_string_attribute`  |
| `set_class_attribute` | `class_attribute=`      |
| `with_attributes`     | `add_attributes`        |

The methods on the left side are meant to be used when defining
attributes in a block when using `#with_attributes` (or `#add_attributes`).

The alias methods are meant to be used for explicitly adding
attributes to an Instances object or defining its class attribute later on.

## Filters

Filters are used to preprocess datasets.

There are two categories of filters which are also reflected by the namespaces:

* *supervised* – The filter requires a class atribute to be set
* *unsupervised* – A class attribute is not required to be present

In each category there are two sub-categories:

* *attribute-based* – Attributes (columns) are processed
* *instance-based* – Instances (rows) are processed

Thus, Filter classes are organized in the following four namespaces:

```ruby
Weka::Filters::Supervised::Attribute
Weka::Filters::Supervised::Instance

Weka::Filters::Unsupervised::Attribute
Weka::Filters::Unsupervised::Instance
```

Filters can be used directly to filter instances:

```ruby
# create filter
filter = Weka::Filters::Unsupervised::Attribute::Normalize.new

# filter instances
filtered_data = filter.filter(instances)
```

You can also apply a Filter on an Instances object:

```ruby
# create filter
filter = Weka::Filters::Unsupervised::Attribute::Normalize.new

# apply filter on instances
filtered_data = instances.apply_filter(filter)
```

With this approach, it is possible to chain multiple filters on a dataset:

```ruby
# create filters
include Weka::Filters::Unsupervised::Attribute

normalize  = Normalize.new
discretize = Discretize.new

# chain filters
filtered_data = instances.apply_filter(normalize).apply_filter(discretize)
```

## Classifiers

## Clusterers

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

## Acknowledgement

The original ideas for wrapping Weka in JRuby come from [@arrigonialberto86](https://github.com/arrigonialberto86) and his [ruby-band](https://github.com/arrigonialberto86/ruby-band) gem. Great thanks!

## License

The gem is available as open source under the terms of the [GNU General Public License](http://www.gnu.org/licenses/gpl-3.0.en.html).
