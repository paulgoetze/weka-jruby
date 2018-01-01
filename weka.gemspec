# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'weka/version'

Gem::Specification.new do |spec|
  spec.name          = 'weka'
  spec.version       = Weka::VERSION
  spec.authors       = ['Paul Götze']
  spec.email         = ['paul.christoph.goetze@gmail.com']

  spec.summary       = 'Machine Learning & Data Mining with JRuby.'
  spec.description   = 'A JRuby wrapper for the Weka library (http://www.cs.waikato.ac.nz/ml/weka/)'
  spec.homepage      = 'https://github.com/paulgoetze/weka-jruby'
  spec.license       = 'MIT'

  spec.platform               = 'java'
  spec.required_ruby_version  = '~> 2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler',          '~> 1.6'
  spec.add_development_dependency 'rake',             '~> 10.0'
  spec.add_development_dependency 'rspec',            '~> 3.0'
  spec.add_development_dependency 'shoulda-matchers', '~> 3.0'

  spec.add_runtime_dependency 'jar-dependencies', '~> 0.3.11'
  spec.requirements << 'jar nz.ac.waikato.cms.weka, weka-dev, 3.9.2'
end
