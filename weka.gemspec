# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'weka/version'

Gem::Specification.new do |spec|
  spec.name          = 'weka'
  spec.version       = Weka::VERSION
  spec.authors       = ['Paul Götze']
  spec.email         = ['paul.christoph.goetze@gmail.com']

  spec.summary       = %q{Machine Learning & Data Mining with JRuby.}
  spec.description   = %q{A wrapper for the Weka library (http://www.cs.waikato.ac.nz/ml/weka/)}
  spec.homepage      = 'https://github.com/paulgoetze/weka-jruby'
  spec.license       = 'GPLv3'

  spec.platform               = 'java'
  spec.required_ruby_version  = '~> 2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency     'lock_jar',         '~> 0.13'
  spec.add_runtime_dependency     'activesupport',    '~> 4.0'

  spec.add_development_dependency 'bundler',          '~> 1.6'
  spec.add_development_dependency 'rake',             '~> 10.0'
  spec.add_development_dependency 'rspec',            '~> 3.0'
  spec.add_development_dependency 'shoulda-matchers', '~> 3.0'
end
