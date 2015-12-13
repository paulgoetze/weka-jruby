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

#### Creating Instances

Attributes of an Instances object can be defined in a block using the `with_attributes` method. The class attribute can be set by the `class_attribute: true` option on the fly with defining an attribute.

```ruby
# create instances with relation name 'weather' and attributes
instances = Weka::Core::Instances.new(relation_name: 'weather').with_attributes do
  nominal :outlook, values: ['sunny', 'overcast', 'rainy']
  numeric :temperature
  numeric :humidity
  nominal :windy, values: [true, false]
  date    :last_storm, 'yyyy-MM-dd'
  nominal :play, values: [:yes, :no], class_attribute: true
end
```

You can also pass an array of Attributes on instantiating new Instances:
This is useful, if you want to create a new empty Instances object with the same
attributes as an already existing one:

```ruby
# Take attributes from existing instances
attributes = instances.attributes

# create an empty Instances object with the given attributes
test_instances = Weka::Core::Instances.new(attributes: attributes)
```

#### Saving Instances as files

You can save Instances as ARFF, CSV, or JSON file.

```ruby
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

Multiple instances can be added with the `add_instances` method:

```ruby
data = [
  [:sunny, 70, 80, true, '2015-12-06', :yes, 1.1, :hm, '2015-12-24 20:00'],
  [:overcast, 80, 85, false, '2015-11-11', :no, 0.9, :bad, '2015-12-25 18:13']
]

instances.add_instances(data, weight: 2.0)
```

If the `weight` argument is not given, then a default weight of 1.0 is used.
The weight in `add_instances` is used for all the added instances.

#### Setting a class attribute

You can set an earlier defined attribute as the class attribute of the dataset.
This allows classifiers to use the class for building a classification model while training.

```ruby
instances.add_nominal_attribute(:size, values: ['L', 'XL'])
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

#### Filtering Instances

Filters can be used directly to filter Instances:

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

# apply a filter chain on instances
filtered_data = instances.apply_filter(normalize).apply_filter(discretize)
```

#### Setting Filter options

Any Filter has several options. You can list a description of all options of a filter:

```ruby
puts Weka::Filters::Unsupervised::Attribute::Normalize.options
# -S <num> The scaling factor for the output range.
#   (default: 1.0)
# -T <num>  The translation of the output range.
#   (default: 0.0)
# -unset-class-temporarily  Unsets the class index temporarily before the filter is
#   applied to the data.
#   (default: no)
```

To get the default option set of a Filter you can run `.default_options`:

```ruby
Weka::Filters::Unsupervised::Attribute::Normalize.default_options
# => '-S 1.0 -T 0.0'
```

Options can be set while building a Filter:

```ruby
filter = Weka::Filters::Unsupervised::Attribute::Normalize.build do
  use_options '-S 0.5'
end
```

Or they can be set or changed after you created the Filter:

```ruby
filter = Weka::Filters::Unsupervised::Attribute::Normalize.new
filter.use_options('-S 0.5')
```

## Attribute selection

## Classifiers

Weka‘s classification and regression algorithms can be found in the `Weka::Classifiers`
namespace.

The classifier classes are organised in the following submodules:

```ruby
Weka::Classifiers::Bayes
Weka::Classifiers::Functions
Weka::Classifiers::Lazy
Weka::Classifiers::Meta
Weka::Classifiers::Rules
Weka::Classifiers::Trees
```

#### Getting information about a classifier

To get a description about the classifier class and its available options
you can use the class methods `.description` and `.options` on each classifier:

```ruby
puts Weka::Classifiers::Trees::RandomForest.description
# Class for constructing a forest of random trees.
# For more information see:
# Leo Breiman (2001). Random Forests. Machine Learning. 45(1):5-32.

puts Weka::Classifiers::Trees::RandomForest.options
# -I <number of trees>  Number of trees to build.
#   (default 100)
# -K <number of features> Number of features to consider (<1=int(log_2(#predictors)+1)).
#   (default 0)
# ...

```

The default options that are used for a classifier can be displayed with:

```ruby
Weka::Classifiers::Trees::RandomForest.default_options
# => "-I 100 -K 0 -S 1 -num-slots 1"
```

#### Creating a new classifier

For building a new classifiers model based on training instances you can use
the following syntax:

```ruby
instances = Weka::Core::Instances.from_arff('weather.arff')
instances.class_attribute = :play

classifier = Weka::Classifiers::Trees::RandomForest.new
classifier.use_options('-I 200 -K 5')
classifier.train_with_instances(instances)
```
You can also build a classifier by using the block syntax:

```ruby
classifier = Weka::Classifiers::Trees::RandomForest.build do
  use_options '-I 200 -K 5'
  train_with_instances instances
end

```

#### Evaluating a classifier model

You can evaluate the trained classifier using [cross-validation](https://en.wikipedia.org/wiki/Cross-validation_(statistics)):

```ruby
# default number of folds is 3
evaluation = classifier.cross_validate

# with a custom number of folds
evaluation = classifier.cross_validate(folds: 10)

# validate the model on a set of test instances
test_instances = Weka::Core::Instances.from_arff('test_data.arff')
evaluation = classifier.cross_validate(test_instances: test_instances, folds: 10)
```

If no test instances are given, the cross validation uses the training instances as test data.

The cross-validation returns a `Weka::Classifiers::Evaluation` object which can be used to get details about the accuracy of the trained classification model:

```ruby
puts evaluation.summary
#
# Correctly Classified Instances          10               71.4286 %
# Incorrectly Classified Instances         4               28.5714 %
# Kappa statistic                          0.3778
# Mean absolute error                      0.4098
# Root mean squared error                  0.4657
# Relative absolute error                 87.4588 %
# Root relative squared error             96.2945 %
# Coverage of cases (0.95 level)         100      %
# Mean rel. region size (0.95 level)      96.4286 %
# Total Number of Instances               14
```

The evaluation holds detailed information about a number of different meassures of interest,
like the [precision and recall](https://en.wikipedia.org/wiki/Precision_and_recall), the FP/FN/TP/TN-rates, [F-Measure](https://en.wikipedia.org/wiki/F1_score) and the areas under PRC and [ROC](https://en.wikipedia.org/wiki/Receiver_operating_characteristic) curve.

## Clusterers

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` or `rake irb` for an interactive prompt that will allow you to experiment.

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

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
