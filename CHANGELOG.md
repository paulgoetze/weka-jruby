# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.6.0] – 2017-12-17
### Added
- #copy method for Weka::Core::Instances

### Changed
- Load Jars with jar-dependencies instead of lock_jar gem
- Make Weka::Core::Instances#instance_from public

### Fixed
- Weka::UnassignedTrainingInstancesError when running #classify/#cluster and
  #distribution_for on deserialized classfiers and clusterers


## [0.5.0] – 2017-06-17
### Added
- #to_m (to Matrix) method for Weka::Core::Instances
- Curve classes in Weka::Classifiers::Evaluation module
- Allow including additional modules on class building
- Rubocop config for project

### Changed
- Allow passing a hash to Weka::Core::Instances#add_instance

### Removed
- Block argument in Weka::Core::Instances#initialize


## [0.4.0] – 2016-12-22
### Added
- C45 converters
- Full support for string attributes

### Removed
- ActiveSupport as dependency


## [0.3.0] – 2016-02-10
### Added
- Allow adding Instances with missing values
- Allow creating DenseInstances with missing values
- #merge method for Weka::Core:Instances


## [0.2.0] – 2016-01-19
### Added
- Serialization/deserialization functionality
- #apply_filters method for Weka::Core::Instances


## [0.1.0] – 2015-12-26
Initial release

[Unreleased]: https://github.com/paulgoetze/weka-jruby/compare/v0.6.0...HEAD
[0.6.0]: https://github.com/paulgoetze/weka-jruby/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/paulgoetze/weka-jruby/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/paulgoetze/weka-jruby/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/paulgoetze/weka-jruby/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/paulgoetze/weka-jruby/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/paulgoetze/weka-jruby/compare/ce6a985017c28ea755290a9baba4d81acddc2d20...v0.1.0
